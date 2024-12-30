---
template: main.html
---

# WaLSAtools

!!! walsa-wheel "The Python package and its documentation are currently under development ....."


<div class="logo">
    <img src="assets/WaLSA_logo.png" alt="WaLSA Logo" style="width: 300px;">
</div>

<div class="dropdown-container">
    <label for="category">Category:</label>
    <select id="category">
        <option value="">Select a category</option>
        <option value="single_series">Single Time Series Analysis</option>
        <option value="cross_correlation">Cross-Correlation Between Two Time Series</option>
    </select>

    <label for="data_type">Data Type:</label>
    <select id="data_type" disabled>
        <option value="">Select a data type</option>
    </select>

    <label for="method">Method:</label>
    <select id="method" disabled>
        <option value="">Select a method</option>
    </select>
</div>

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

    const categoryDropdown = document.getElementById("category");
    const dataTypeDropdown = document.getElementById("data_type");
    const methodDropdown = document.getElementById("method");
    const callingSequence = document.getElementById("callingSequence");
    const parameterTableBody = document.getElementById("parameterTableBody");

    categoryDropdown.addEventListener("change", () => {
        const category = categoryDropdown.value;
        dataTypeDropdown.innerHTML = '<option value="">Select a data type</option>';
        methodDropdown.innerHTML = '<option value="">Select a method</option>';
        dataTypeDropdown.disabled = !category;
        methodDropdown.disabled = true;

        if (category === "single_series") {
            dataTypeDropdown.innerHTML += '<option value="1D">1D Signal</option>';
        } else if (category === "cross_correlation") {
            dataTypeDropdown.innerHTML += '<option value="1D">1D Signal</option>';
        }
    });

    dataTypeDropdown.addEventListener("change", () => {
        const dataType = dataTypeDropdown.value;
        methodDropdown.innerHTML = '<option value="">Select a method</option>';
        methodDropdown.disabled = !dataType;

        if (dataType === "1D") {
            const category = categoryDropdown.value;
            if (category === "single_series") {
                Object.keys(parameters.single_series).forEach((method) => {
                    methodDropdown.innerHTML += `<option value="${method}">${method.toUpperCase()}</option>`;
                });
            } else if (category === "cross_correlation") {
                Object.keys(parameters.cross_correlation).forEach((method) => {
                    methodDropdown.innerHTML += `<option value="${method}">${method.toUpperCase()}</option>`;
                });
            }
        }
    });

    methodDropdown.addEventListener("change", () => {
        const method = methodDropdown.value;
        const category = categoryDropdown.value;

        let selectedParams = parameters[category]?.[method];

        if (selectedParams) {
            const { returnValues, parameters: params } = selectedParams;

            // Update calling sequence
            callingSequence.textContent = `>>> ${returnValues} = WaLSAtools(data, method="${method}", **kwargs)`;

            // Update parameter table
            parameterTableBody.innerHTML = Object.entries(params)
                .map(
                    ([param, { type, description }]) =>
                        `<tr><td>${param}</td><td>${type}</td><td>${description}</td></tr>`
                )
                .join("");
        }
    });
</script>