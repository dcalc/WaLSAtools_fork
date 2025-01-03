---
template: main.html
---

# WaLSAtools

**WaLSAtools** is designed for ease of use and accessibility. Its interactive interface guides you through the analysis process, providing clear instructions and helpful information at each step. This section demonstrates how to use WaLSAtools and highlights its key features.

Before diving into the interactive demonstration, we recommend familiarizing yourself with the various analysis methods available in WaLSAtools. You can find detailed descriptions of these methods in the [Introduction](introduction.md) section. Additionally, this page provides several **Worked Examples** of different analysis techniques applied to synthetic datasets (see the left menu). To learn more about its capabilities and how to apply it to your research, we encourage you to explore the WaLSAtools documentation, the associated *Nature Reviews Methods Primers* article, and the provided examples. If you use WaLSAtools in your work, please remember to cite it appropriately (see [Citation](citation.md)).

The ["Under the Hood"](routines.md) section provides details on the individual routines used for wave analysis within the **WaLSAtools** package, for those interested in exploring the underlying code. However, we strongly encourage all users to perform their analyses by running WaLSAtools directly, as this ensures the correct execution of the analysis workflow and provides a more user-friendly experience.

!!! walsa-gear "Interactive Demonstration"

    WaLSAtools provides an interactive interface that simplifies wave analysis. To launch the interface, simply import the `WaLSAtools` package and run the `WaLSAtools` command in a Python terminal or Jupyter notebook.

    The interface will guide you through the following steps:

    1.  **Select a category of analysis:** Choose from single time series analysis or cross-correlation analysis.
    2.  **Choose the data type:** Specify the type of data you are working with (e.g., 1D signal, 3D datacube).
    3.  **Pick a specific analysis method:** Select the method most suitable for your data and research question.

    The interface will then provide information on the selected method, including its calling sequence, input parameters, and expected outputs.

    **Here's an example of the execution of WaLSAtools in a Jupyter notebook:**

<style>
    .dropdown-container {
        margin-left: 30px;
        margin-top: 20px;
        font-size: 0.9em;
        line-height: 2;
        display: flex;
        flex-direction: column;
        gap: 10px;
    }
    .dropdown-row {
        display: flex;
        align-items: center;
        gap: 10px;
    }   
    select {
        width: 270px;
        height: 33px;
        padding: 5px 10px;
        font-size: 1em;
        color: #333;
        border: 1px solid #ccc;
        border-radius: 2px;
        background-color: #f9f9f9;
        appearance: none;
        -webkit-appearance: none;
        -moz-appearance: none;
        background-image: url('data:image/svg+xml,%3Csvg xmlns="http://www.w3.org/2000/svg" width="12" height="12" viewBox="0 0 12 12"%3E%3Cpath d="M1,4 L6,9 L11,4" fill="none" stroke="%23000" stroke-width="2.0" /%3E%3C/svg%3E');
        background-repeat: no-repeat;
        background-position: right 10px center;
        background-size: 12px 12px;
        cursor: pointer;
    }
    select:focus {
        outline: none;
        border-color: #4caf50;
        box-shadow: 0 0 5px rgba(76, 175, 80, 0.6);
    }
    select:disabled {
        background-color: #eaeaea;
        cursor: not-allowed;
    }   
    .output-container {
        margin-left: 30px;
        margin-top: 5px;
        padding: 0;
        display: none; /* Hidden by default */
    }
    .parameters-table {
        border-collapse: collapse;
        border: 1px solid #222;
        width: calc(100% - 30px);
        box-sizing: border-box;
        table-layout: auto;
        margin-top: 20px;
        font-size: 0.9em;
    }
    .parameters-table td {
        border: 1px solid #222;
        padding: 8px;
        text-align: left;
    }
    .parameters-table th {
        padding: 8px;
        text-align: left;
    }   
    .code-container {
        font-family: monospace;
        position: relative;
        background-color: #f7f7f7;
        border: 1px solid #ddd;
        margin-left: 30px; /* Align box to the right of the Execute button */
        padding: 10px;
        padding-left: 40px; /* For line numbers */
        font-size: 14px;
        line-height: 1.6;
        display: inline-block;
        width: calc(100% - 30px);
        box-sizing: border-box;
    }
    .line-numbers {
        position: absolute;
        top: 10px;
        left: 10px;
        color: #888;
        text-align: right;
        line-height: 1.6;
        font-size: 14px;
    }
    .execute-btn {
        background-color: #4caf50;
        color: white;
        border: none;
        border-radius: 50%;
        width: 20px;
        height: 20px;
        display: flex;
        justify-content: center;
        align-items: center;
        font-size: 16px;
        font-weight: bold;
        cursor: pointer;
        position: absolute;
        left: -30px; /* Place the button outside the box */
        top: 2px;
    }
    .execute-btn:hover {
        background-color: #45a049;
    }
    .index-number {
        position: absolute;
        bottom: 0px;
        left: -30px;
        color: #888;
        font-size: 12px;
    }
    .python-label {
        position: absolute;
        bottom: 2px;
        right: 6px;
        font-size: 12px;
        color: #888;
    }
    .walsa-gear-code {
        border-left: 4px solid rgb(189, 26, 31); 
        background-color: rgba(255, 255, 255, 0.1);
        padding: 16px; 
        border-radius: 1px; 
        margin-bottom: 16px; 
        box-shadow: 0px 4px 6px rgba(0, 0, 0, 0.1);
    }
</style>
<div class="walsa-gear-code">
<div style="font-family: Arial, sans-serif; margin: 20px; font-size: 0.9em; line-height: 0.9em;">
<div class="code-container">
    <!-- Line numbers -->
    <div class="line-numbers">
        1<br>
        2
    </div>
    <!-- Code area -->
    <div>
        <span style="color:DodgerBlue">from</span> WaLSAtools <span style="color:DodgerBlue">import</span> WaLSAtools<br>
        WaLSAtools
    </div>
    <!-- Execute button -->
    <!-- <button class="execute-btn">▶</button> -->
    <!-- Index number -->
    <div class="index-number">[1]</div>  
    <!-- Python label -->
    <div class="python-label">Python</div>
</div>
<!-- Logo -->
<div style="margin-left: 30px; margin-top: 20px;">
    <img src="https://walsa.team/images/WaLSA_logo.png" style="width: 300px; height: auto;">
</div>
<!-- Credits -->
<div style="margin-left: 30px; margin-top: 20px; font-size: 0.9em;">
    <p>© WaLSA Team (<a href="https://www.WaLSA.team" target="_blank" style="color: #4169E1; text-decoration: none;">www.WaLSA.team</a>)</p>
    <hr style="width: 70%; margin: 0; border: 0.98px solid #888; margin-bottom: 10px;">
    <p><strong>WaLSAtools</strong> v1.0 - Wave analysis tools</p>
    <p>Documentation: <a href="https://www.WaLSA.tools" target="_blank" style="color: #4169E1; text-decoration: none;">www.WaLSA.tools</a></p>
    <p>GitHub repository: <a href="https://www.github.com/WaLSAteam/WaLSAtools" target="_blank" style="color: #4169E1; text-decoration: none;">www.github.com/WaLSAteam/WaLSAtools</a></p>
    <hr style="width: 70%; margin: 0; border: 0.98px solid #888; margin-bottom: 10px;">
    <p>If you use <strong>WaLSAtools</strong> in your research, please cite:</p>
    <p>Jafarzadeh, S., Jess, D. B., Stangalini, M. et al. 2025, <em>Nature Reviews Methods Primers</em>, in press</p>
    <hr style="width: 70%; margin: 0; border: 0.98px solid #888; margin-bottom: 15px;">
    <p>Choose a category, data type, and analysis method from the list below,</p>
    <p>to get hints on the calling sequence and parameters:</p>
</div>
<!-- Dropdown Menus -->
<div class="dropdown-container">
    <div class="dropdown-row">
        <label for="category" style="width: 90px !important; text-align: right !important;">Category:</label>
        <select id="category">
            <option value="">Select Category</option>
            <option value="a">Single Time Series Analysis</option>
            <option value="b">Cross-Correlation Between Two Time Series</option>
        </select>
    </div>
    <div class="dropdown-row">
        <label for="datatype" style="width: 90px !important; text-align: right !important;">Data Type:</label>
        <select id="datatype" disabled>
            <option value="">Select Data Type</option>
        </select>
    </div>
    <div class="dropdown-row">
        <label for="analysisMethod" style="width: 90px !important; text-align: right !important;">Method:</label>
        <select id="analysisMethod" disabled>
            <option value="">Select Method</option>
        </select>
    </div>
    <div class="dropdown-row">
        <label for="subMethod" id="subMethodLabel" style="width: 90px !important; text-align: right !important; display:none;">Sub-method:</label>
        <select id="subMethod" style="display:none;">
            <option value="">Select Sub-method</option>
            <option value="fft">FFT</option>
            <option value="wavelet">Wavelet</option>
            <option value="lombscargle">Lomb-Scargle</option>
            <option value="welch">Welch</option>
        </select>
    </div>
</div>
<div id="dropdownMessage" style="margin-left: 30px; margin-top: 15px; font-size: 0.9em; display: none;">
    Please select appropriate options from all dropdown menus.
</div>
<div class="output-container" id="outputContainer">
    <p style="font-size: 1.0em;">Calling Sequence:</p>
    <span id="callingSequence" style="font-size: 0.95em !important; margin: 0 !important; padding: 0 !important;"></span>
    <table class="parameters-table">
        <thead>
            <tr style="background-color: #fff;"><th colspan="3" style="text-align: left; color: #000; font-size: 110%;">Parameters (**kwargs)</th></tr>
            <tr style="background-color: #222;">
                <th style="color: #fff; border-right: 1px solid #ccc; text-align: left; white-space: nowrap;">Parameter</th>
                <th style="color: #fff; border-right: 1px solid #ccc; text-align: left; white-space: nowrap;">Type</th>
                <th style="color: #fff; text-align: left; width: 100%;">Description</th>
            </tr>
        </thead>
        <tbody id="parameterTableBody">
        </tbody>
    </table>
</div>
</div>
</div>

<link rel="preload" href="walsatools_interactive.js" as="script">
<script src="walsatools_interactive.js" defer></script>

??? source-code "Source code"
    ``` python linenums="1"
    --8<-- "codes/python/WaLSAtools/WaLSAtools.py"
    ```
