---
template: main.html
---

# WaLSAtools

!!! walsa-wheel "The Python package and its documentation are currently under development ....."


<div class="logo">
    <img src="codes/python/WaLSAtools/assets/WaLSA_logo.png" alt="WaLSA Logo" style="width: 300px;">
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

<div class="output-container">
    <h3>Calling Sequence</h3>
    <pre id="callingSequence">Select options to generate the calling sequence.</pre>

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
            <tr>
                <td colspan="3" style="text-align: center;">No parameters available yet.</td>
            </tr>
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
            },
            wavelet: {
                returnValues: "power, period, significance, coi, gws_power",
                parameters: {
                    signal: { type: "array", description: "The input signal (1D)." },
                    time: { type: "array", description: "The time array corresponding to the signal." }
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
    const callingSequence = document.getElementById('callingSequence');
    const parameterTableBody = document.getElementById('parameterTableBody');

    // Update Data Type options based on Category
    categoryDropdown.addEventListener('change', () => {
        const category = categoryDropdown.value;
        methodDropdown.innerHTML = '<option value="">Select Data Type</option>';
        analysisTypeDropdown.innerHTML = '<option value="">Select Method</option>';
        subMethodDropdown.style.display = 'none';
        subMethodLabel.style.display = 'none';
        methodDropdown.disabled = !category;

        if (category === 'a') {
            methodDropdown.innerHTML += '<option value="1">1D Signal</option>';
            methodDropdown.innerHTML += '<option value="2">3D Datacube</option>';
        } else if (category === 'b') {
            methodDropdown.innerHTML += '<option value="1">1D Signal</option>';
        }
    });

    // Update Method options based on Data Type
    methodDropdown.addEventListener('change', () => {
        const method = methodDropdown.value;
        analysisTypeDropdown.innerHTML = '<option value="">Select Method</option>';
        analysisTypeDropdown.disabled = !method;

        if (categoryDropdown.value === 'a' && method === '1') {
            analysisTypeDropdown.innerHTML += `
                <option value="fft">FFT</option>
                <option value="wavelet">Wavelet</option>
                <option value="lombscargle">Lomb-Scargle</option>
                <option value="welch">Welch</option>`;
        } else if (categoryDropdown.value === 'a' && method === '2') {
            analysisTypeDropdown.innerHTML += `
                <option value="k-omega">k-omega</option>
                <option value="pod">POD</option>
                <option value="dominant_freq">Dominant Freq / Mean Power Spectrum</option>`;
        } else if (categoryDropdown.value === 'b' && method === '1') {
            analysisTypeDropdown.innerHTML += `
                <option value="wavelet">Wavelet</option>
                <option value="welch">Welch</option>`;
        }
    });

    // Show or hide Sub-method dropdown
    analysisTypeDropdown.addEventListener('change', () => {
        const analysisType = analysisTypeDropdown.value;

        if (categoryDropdown.value === 'a' && methodDropdown.value === '2' && analysisType === 'dominant_freq') {
            subMethodDropdown.style.display = 'inline-block';
            subMethodLabel.style.display = 'inline-block';
        } else {
            subMethodDropdown.style.display = 'none';
            subMethodLabel.style.display = 'none';
        }

        updateCallingSequence();
    });

    // Update the Calling Sequence
    subMethodDropdown.addEventListener('change', updateCallingSequence);
    analysisTypeDropdown.addEventListener('change', updateCallingSequence);

    function updateCallingSequence() {
        const category = categoryDropdown.value;
        const method = methodDropdown.value;
        const analysisType = analysisTypeDropdown.value;
        const subMethod = subMethodDropdown.value;

        if (!category || !method || !analysisType || (subMethodDropdown.style.display === 'inline-block' && !subMethod)) {
            callingSequence.textContent = "Select options to generate the calling sequence.";
            return;
        }

        let command = "";

        if (category === 'a' && method === '1') {
            const methodMap = { fft: 'FFT', wavelet: 'Wavelet', lombscargle: 'Lomb-Scargle', welch: 'Welch' };
            command = `>>> power, frequency, significance = WaLSAtools(signal=INPUT_DATA, time=TIME_ARRAY, method='${analysisType}', **kwargs)`;
        } else if (category === 'a' && method === '2') {
            if (analysisType === 'dominant_freq') {
                command = `>>> dominant_frequency, mean_power = WaLSAtools(data=INPUT_DATA, method='${subMethod}', **kwargs)`;
            } else {
                command = `>>> results = WaLSAtools(data=INPUT_DATA, method='${analysisType}', **kwargs)`;
            }
        } else if (category === 'b') {
            command = `>>> cross_power, coherence = WaLSAtools(data1=INPUT_DATA1, data2=INPUT_DATA2, method='${analysisType}', **kwargs)`;
        }

        callingSequence.textContent = command;

        // Update parameter table dynamically
        updateParameterTable(analysisType, subMethod || analysisType);
    }

    function updateParameterTable(analysisType, method) {
        parameterTableBody.innerHTML = "";

        const paramData =
            parameters.single_series[method]?.parameters ||
            parameters.cross_correlation[method]?.parameters;

        if (!paramData) {
            parameterTableBody.innerHTML = `<tr><td colspan="3" style="text-align: center;">No parameters available.</td></tr>`;
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