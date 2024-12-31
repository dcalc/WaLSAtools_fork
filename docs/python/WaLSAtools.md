---
template: main.html
---

# WaLSAtools

!!! walsa-wheel "The Python package and its documentation are currently under development ....."


<div class="logo">
    <img src="https://walsa.tools/images/WaLSA_logo.png" alt="WaLSA Logo" style="width: 300px;">
</div>

<!-- Dropdown Menus -->
<label for="category">Category:</label>
<select id="category">
    <option value="">Select Category</option>
    <option value="a">Single Time Series Analysis</option>
    <option value="b">Cross-Correlation Between Two Time Series</option>
</select>

<label for="method">Data Type:</label>
<select id="method" disabled>
    <option value="">Select Data Type</option>
</select>

<label for="analysisType">Method:</label>
<select id="analysisType" disabled>
    <option value="">Select Method</option>
</select>

<label for="subMethod" id="subMethodLabel" style="display:none;">Sub-method:</label>
<select id="subMethod" style="display:none;">
    <option value="">Select Sub-method</option>
    <option value="fft">FFT</option>
    <option value="wavelet">Wavelet</option>
    <option value="lombscargle">Lomb-Scargle</option>
    <option value="welch">Welch</option>
</select>

<div class="output-container" id="outputContainer">
    <h3>Calling Sequence</h3>
    <pre id="callingSequence"></pre>

    <h3>Parameter Table</h3>
    <table class="parameters-table">
        <thead>
            <tr>
                <th>Parameter</th>
                <th>Type</th>
                <th>Description</th>
            </tr>
        </thead>
        <tbody id="parameterTableBody">
        </tbody>
    </table>
</div>

<script>
    const parameters = {
        single_series: {
            fft: {
                returnValues: "power, frequency, significance, amplitude",
                parameters: {
                    signal: { type: "array", description: "The input signal (1D)." },
                    time: { type: "array", description: "The time array corresponding to the signal." },
                    siglevel: { type: "float", description: "Significance level for confidence intervals. Default: 0.95." }
                }
            }
        },
        cross_correlation: {
            wavelet: {
                returnValues: "cross_power, coherence",
                parameters: {
                    data1: { type: "array", description: "First time series signal." },
                    data2: { type: "array", description: "Second time series signal." },
                    time: { type: "array", description: "The time array corresponding to the signals." }
                }
            }
        }
    };

    const categoryDropdown = document.getElementById('category');
    const methodDropdown = document.getElementById('method');
    const analysisTypeDropdown = document.getElementById('analysisType');
    const subMethodDropdown = document.getElementById('subMethod');
    const subMethodLabel = document.getElementById('subMethodLabel');
    const outputContainer = document.getElementById('outputContainer');
    const callingSequence = document.getElementById('callingSequence');
    const parameterTableBody = document.getElementById('parameterTableBody');

    function resetDropdown(dropdown) {
        dropdown.innerHTML = '<option value="">Select ...</option>';
        dropdown.disabled = true;
    }

    function hideOutput() {
        outputContainer.style.display = 'none';
    }

    function clearOutput() {
        callingSequence.textContent = '';
        parameterTableBody.innerHTML = '';
        hideOutput();
    }

    // Event Listener for Category Dropdown
    categoryDropdown.addEventListener('change', () => {
        const category = categoryDropdown.value;
        resetDropdown(methodDropdown);
        resetDropdown(analysisTypeDropdown);
        subMethodDropdown.style.display = 'none';
        subMethodLabel.style.display = 'none';
        clearOutput();

        if (category) {
            methodDropdown.disabled = false;
            if (category === 'a') {
                methodDropdown.innerHTML += `
                    <option value="1">1D Signal</option>
                    <option value="2">3D Datacube</option>`;
            } else if (category === 'b') {
                methodDropdown.innerHTML += `<option value="1">1D Signal</option>`;
            }
        }
    });

    // Event Listener for Method Dropdown
    methodDropdown.addEventListener('change', () => {
        const method = methodDropdown.value;
        resetDropdown(analysisTypeDropdown);
        subMethodDropdown.style.display = 'none';
        subMethodLabel.style.display = 'none';
        clearOutput();

        if (method) {
            analysisTypeDropdown.disabled = false;
            if (categoryDropdown.value === 'a' && method === '1') {
                analysisTypeDropdown.innerHTML += `
                    <option value="fft">FFT</option>
                    <option value="wavelet">Wavelet</option>`;
            } else if (categoryDropdown.value === 'a' && method === '2') {
                analysisTypeDropdown.innerHTML += `
                    <option value="k-omega">k-omega</option>
                    <option value="pod">POD</option>`;
            } else if (categoryDropdown.value === 'b') {
                analysisTypeDropdown.innerHTML += `
                    <option value="wavelet">Wavelet</option>`;
            }
        }
    });

    // Event Listener for Analysis Type Dropdown
    analysisTypeDropdown.addEventListener('change', () => {
        const analysisType = analysisTypeDropdown.value;
        subMethodDropdown.style.display = 'none';
        subMethodLabel.style.display = 'none';
        clearOutput();

        if (analysisType === 'dominant_freq' && categoryDropdown.value === 'a' && methodDropdown.value === '2') {
            subMethodDropdown.style.display = 'inline-block';
            subMethodLabel.style.display = 'inline-block';
        }

        updateOutput();
    });

    // Event Listener for Sub-method Dropdown
    subMethodDropdown.addEventListener('change', updateOutput);

    // Update Output Container
    function updateOutput() {
        const category = categoryDropdown.value;
        const method = methodDropdown.value;
        const analysisType = analysisTypeDropdown.value;
        const subMethod = subMethodDropdown.value;

        if (!category || !method || !analysisType || (subMethodDropdown.style.display === 'inline-block' && !subMethod)) {
            hideOutput();
            return;
        }

        let command = '';
        if (category === 'a' && method === '1') {
            command = `>>> power, frequency = WaLSAtools(signal=INPUT_DATA, method='${analysisType}')`;
        } else if (category === 'b') {
            command = `>>> cross_power = WaLSAtools(data1=INPUT_DATA1, method='${analysisType}')`;
        }

        callingSequence.textContent = command;
        updateParameterTable(analysisType);
        outputContainer.style.display = 'block';
    }

    function updateParameterTable(method) {
        parameterTableBody.innerHTML = '';
        const paramData =
            parameters.single_series[method]?.parameters ||
            parameters.cross_correlation[method]?.parameters;

        if (!paramData) {
            parameterTableBody.innerHTML = `
                <tr>
                    <td colspan="3" style="text-align: center;">No parameters available.</td>
                </tr>`;
            return;
        }

        Object.entries(paramData).forEach(([key, value]) => {
            parameterTableBody.innerHTML += `
                <tr>
                    <td>${key}</td>
                    <td>${value.type}</td>
                    <td>${value.description}</td>
                </tr>`;
        });
    }
</script>