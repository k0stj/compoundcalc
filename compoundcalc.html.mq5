<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Compound Interest Calculator</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600;700&display=swap" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <style>
        body {
            font-family: 'Inter', sans-serif;
            background-color: #f3f4f6; /* Light gray background */
        }
        /* Custom styles for active currency button */
        .currency-button.active {
            background-color: #1e40af; /* Darker blue for active state */
            border-color: #1e40af;
            color: white;
            box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1), 0 2px 4px -1px rgba(0, 0, 0, 0.06);
        }
        /* Styles for tooltips */
        .tooltip-container {
            position: relative;
            display: inline-block;
        }
        .tooltip-text {
            visibility: hidden;
            background-color: #374151; /* gray-700 */
            color: #fff;
            text-align: center;
            border-radius: 6px;
            padding: 5px 8px;
            position: absolute;
            z-index: 10;
            bottom: 125%; /* Position above the icon */
            left: 50%;
            transform: translateX(-50%);
            opacity: 0;
            transition: opacity 0.3s;
            white-space: nowrap; /* Keep text on one line */
            font-size: 0.75rem; /* text-xs */
        }
        .tooltip-text::after {
            content: "";
            position: absolute;
            top: 100%;
            left: 50%;
            margin-left: -5px;
            border-width: 5px;
            border-style: solid;
            border-color: #374151 transparent transparent transparent;
        }
        .tooltip-container:hover .tooltip-text,
        .tooltip-container:focus-within .tooltip-text {
            visibility: visible;
            opacity: 1;
        }
    </style>
</head>
<body class="flex items-center justify-center min-h-screen p-4">
    <div class="bg-white p-8 rounded-lg shadow-xl w-full max-w-md">
        <h1 class="text-3xl font-bold text-center text-gray-800 mb-6">Compound Interest Calculator</h1>

        <div class="mb-6 flex justify-center space-x-2">
            <button id="currencyUSD" class="currency-button px-4 py-2 rounded-lg border-2 border-blue-400 text-blue-700 font-semibold hover:bg-blue-100 focus:outline-none focus:ring-2 focus:ring-blue-500 focus:ring-opacity-50 transition duration-200 active" data-currency="$">USD ($)</button>
            <button id="currencyGBP" class="currency-button px-4 py-2 rounded-lg border-2 border-blue-400 text-blue-700 font-semibold hover:bg-blue-100 focus:outline-none focus:ring-2 focus:ring-blue-500 focus:ring-opacity-50 transition duration-200" data-currency="£">GBP (£)</button>
            <button id="currencyEUR" class="currency-button px-4 py-2 rounded-lg border-2 border-blue-400 text-blue-700 font-semibold hover:bg-blue-100 focus:outline-none focus:ring-2 focus:ring-blue-500 focus:ring-opacity-50 transition duration-200" data-currency="€">EUR (€)</button>
        </div>

        <div class="mb-4">
            <label for="principal" class="block text-gray-700 text-sm font-semibold mb-2">
                Starting Amount
                <span class="tooltip-container ml-1 text-gray-400 cursor-help" tabindex="0">
                    <svg class="w-4 h-4 inline-block" fill="currentColor" viewBox="0 0 20 20" xmlns="http://www.w3.org/2000/svg"><path fill-rule="evenodd" d="M18 10a8 8 0 11-16 0 8 8 0 0116 0zm-7-4a1 1 0 11-2 0 1 1 0 012 0zM9.293 12.293a1 1 0 001.414 1.414L12 11.414V14a1 1 0 102 0v-2.586l.293.293a1 1 0 001.414-1.414L10 8.586l-4.293 4.293a1 1 0 00-.707.293z" clip-rule="evenodd"></path></svg>
                    <span class="tooltip-text">The initial lump sum of money you invest.</span>
                </span>
            </label>
            <input type="number" id="principal" value="1000" class="shadow appearance-none border rounded-lg w-full py-2 px-3 text-gray-700 leading-tight focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-transparent transition duration-200">
        </div>

        <div class="mb-4">
            <label for="rate" class="block text-gray-700 text-sm font-semibold mb-2">
                Annual Interest Rate (%)
                <span class="tooltip-container ml-1 text-gray-400 cursor-help" tabindex="0">
                    <svg class="w-4 h-4 inline-block" fill="currentColor" viewBox="0 0 20 20" xmlns="http://www.w3.org/2000/svg"><path fill-rule="evenodd" d="M18 10a8 8 0 11-16 0 8 8 0 0116 0zm-7-4a1 1 0 11-2 0 1 1 0 012 0zM9.293 12.293a1 1 0 001.414 1.414L12 11.414V14a1 1 0 102 0v-2.586l.293.293a1 1 0 001.414-1.414L10 8.586l-4.293 4.293a1 1 0 00-.707.293z" clip-rule="evenodd"></path></svg>
                    <span class="tooltip-text">The percentage return your investment earns per year.</span>
                </span>
            </label>
            <input type="number" id="rate" value="5" step="0.1" class="shadow appearance-none border rounded-lg w-full py-2 px-3 text-gray-700 leading-tight focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-transparent transition duration-200">
        </div>

        <div class="mb-4">
            <label for="compounding" class="block text-gray-700 text-sm font-semibold mb-2">
                Compounding Frequency (times per year)
                <span class="tooltip-container ml-1 text-gray-400 cursor-help" tabindex="0">
                    <svg class="w-4 h-4 inline-block" fill="currentColor" viewBox="0 0 20 20" xmlns="http://www.w3.org/2000/svg"><path fill-rule="evenodd" d="M18 10a8 8 0 11-16 0 8 8 0 0116 0zm-7-4a1 1 0 11-2 0 1 1 0 012 0zM9.293 12.293a1 1 0 001.414 1.414L12 11.414V14a1 1 0 102 0v-2.586l.293.293a1 1 0 001.414-1.414L10 8.586l-4.293 4.293a1 1 0 00-.707.293z" clip-rule="evenodd"></path></svg>
                    <span class="tooltip-text">How often the interest is calculated and added to the principal. More frequent compounding leads to higher returns.</span>
                </span>
            </label>
            <select id="compounding" class="shadow appearance-none border rounded-lg w-full py-2 px-3 text-gray-700 leading-tight focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-transparent transition duration-200">
                <option value="1">Annually (1)</option>
                <option value="2">Semi-annually (2)</option>
                <option value="4">Quarterly (4)</option>
                <option value="12" selected>Monthly (12)</option>
                <option value="52">Weekly (52)</option>
                <option value="365">Daily (365)</option>
            </select>
        </div>

        <div class="mb-4">
            <label for="years" class="block text-gray-700 text-sm font-semibold mb-2">
                Number of Years
                <span class="tooltip-container ml-1 text-gray-400 cursor-help" tabindex="0">
                    <svg class="w-4 h-4 inline-block" fill="currentColor" viewBox="0 0 20 20" xmlns="http://www.w3.org/2000/svg"><path fill-rule="evenodd" d="M18 10a8 8 0 11-16 0 8 8 0 0116 0zm-7-4a1 1 0 11-2 0 1 1 0 012 0zM9.293 12.293a1 1 0 001.414 1.414L12 11.414V14a1 1 0 102 0v-2.586l.293.293a1 1 0 001.414-1.414L10 8.586l-4.293 4.293a1 1 0 00-.707.293z" clip-rule="evenodd"></path></svg>
                    <span class="tooltip-text">The total duration for which the investment will compound.</span>
                </span>
            </label>
            <input type="number" id="years" value="10" class="shadow appearance-none border rounded-lg w-full py-2 px-3 text-gray-700 leading-tight focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-transparent transition duration-200">
        </div>

        <div class="mb-4">
            <label for="contributionAmount" class="block text-gray-700 text-sm font-semibold mb-2">
                Regular Contribution Amount
                <span class="tooltip-container ml-1 text-gray-400 cursor-help" tabindex="0">
                    <svg class="w-4 h-4 inline-block" fill="currentColor" viewBox="0 0 20 20" xmlns="http://www.w3.org/2000/svg"><path fill-rule="evenodd" d="M18 10a8 8 0 11-16 0 8 8 0 0116 0zm-7-4a1 1 0 11-2 0 1 1 0 012 0zM9.293 12.293a1 1 0 001.414 1.414L12 11.414V14a1 1 0 102 0v-2.586l.293.293a1 1 0 001.414-1.414L10 8.586l-4.293 4.293a1 1 0 00-.707.293z" clip-rule="evenodd"></path></svg>
                    <span class="tooltip-text">The additional amount you regularly add to your investment.</span>
                </span>
            </label>
            <input type="number" id="contributionAmount" value="0" class="shadow appearance-none border rounded-lg w-full py-2 px-3 text-gray-700 leading-tight focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-transparent transition duration-200">
        </div>

        <div class="mb-6">
            <label for="contributionFrequency" class="block text-gray-700 text-sm font-semibold mb-2">
                Contribution Frequency
                <span class="tooltip-container ml-1 text-gray-400 cursor-help" tabindex="0">
                    <svg class="w-4 h-4 inline-block" fill="currentColor" viewBox="0 0 20 20" xmlns="http://www.w3.org/2000/svg"><path fill-rule="evenodd" d="M18 10a8 8 0 11-16 0 8 8 0 0116 0zm-7-4a1 1 0 11-2 0 1 1 0 012 0zM9.293 12.293a1 1 0 001.414 1.414L12 11.414V14a1 1 0 102 0v-2.586l.293.293a1 1 0 001.414-1.414L10 8.586l-4.293 4.293a1 1 0 00-.707.293z" clip-rule="evenodd"></path></svg>
                    <span class="tooltip-text">How often you make regular contributions (e.g., monthly, yearly).</span>
                </span>
            </label>
            <select id="contributionFrequency" class="shadow appearance-none border rounded-lg w-full py-2 px-3 text-gray-700 leading-tight focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-transparent transition duration-200">
                <option value="0">None</option>
                <option value="1">Yearly</option>
                <option value="12" selected>Monthly</option>
                <option value="52">Weekly</option>
            </select>
        </div>

        <div class="mb-4 flex items-center">
            <input type="checkbox" id="adjustInflation" class="h-4 w-4 text-blue-600 focus:ring-blue-500 border-gray-300 rounded">
            <label for="adjustInflation" class="ml-2 block text-gray-700 text-sm font-semibold">
                Adjust for Inflation
                <span class="tooltip-container ml-1 text-gray-400 cursor-help" tabindex="0">
                    <svg class="w-4 h-4 inline-block" fill="currentColor" viewBox="0 0 20 20" xmlns="http://www.w3.org/2000/svg"><path fill-rule="evenodd" d="M18 10a8 8 0 11-16 0 8 8 0 0116 0zm-7-4a1 1 0 11-2 0 1 1 0 012 0zM9.293 12.293a1 1 0 001.414 1.414L12 11.414V14a1 1 0 102 0v-2.586l.293.293a1 1 0 001.414-1.414L10 8.586l-4.293 4.293a1 1 0 00-.707.293z" clip-rule="evenodd"></path></svg>
                    <span class="tooltip-text">Calculate the future value in terms of today's purchasing power, considering inflation.</span>
                </span>
            </label>
        </div>

        <div class="mb-6" id="inflationRateContainer">
            <label for="inflationRate" class="block text-gray-700 text-sm font-semibold mb-2">
                Yearly Inflation Rate (%)
                <span class="tooltip-container ml-1 text-gray-400 cursor-help" tabindex="0">
                    <svg class="w-4 h-4 inline-block" fill="currentColor" viewBox="0 0 20 20" xmlns="http://www.w3.org/2000/svg"><path fill-rule="evenodd" d="M18 10a8 8 0 11-16 0 8 8 0 0116 0zm-7-4a1 1 0 11-2 0 1 1 0 012 0zM9.293 12.293a1 1 0 001.414 1.414L12 11.414V14a1 1 0 102 0v-2.586l.293.293a1 1 0 001.414-1.414L10 8.586l-4.293 4.293a1 1 0 00-.707.293z" clip-rule="evenodd"></path></svg>
                    <span class="tooltip-text">The average annual rate at which prices are expected to rise.</span>
                </span>
            </label>
            <input type="number" id="inflationRate" value="3" step="0.1" class="shadow appearance-none border rounded-lg w-full py-2 px-3 text-gray-700 leading-tight focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-transparent transition duration-200">
        </div>

        <div class="mb-6 flex justify-center space-x-2">
            <button id="saveScenarioBtn" class="bg-gray-200 hover:bg-gray-300 text-gray-800 font-bold py-2 px-4 rounded-lg focus:outline-none focus:ring-2 focus:ring-gray-400 focus:ring-opacity-50 transition duration-200">
                Save Scenario
            </button>
            <button id="loadScenarioBtn" class="bg-gray-200 hover:bg-gray-300 text-gray-800 font-bold py-2 px-4 rounded-lg focus:outline-none focus:ring-2 focus:ring-gray-400 focus:ring-opacity-50 transition duration-200">
                Load Scenario
            </button>
        </div>


        <button id="calculateBtn" class="bg-blue-600 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded-lg w-full focus:outline-none focus:ring-2 focus:ring-blue-500 focus:ring-opacity-50 transition duration-200 shadow-md">
            Calculate Future Value
        </button>

        <div id="resultContainer" class="mt-8 p-4 bg-blue-50 rounded-lg border border-blue-200 text-blue-800 text-center hidden">
            <p class="text-lg font-semibold">Future Value:</p>
            <p id="result" class="text-2xl font-bold mt-2 mb-4"></p>
            <p class="text-md">Total Contributions: <span id="totalContributions" class="font-bold"></span></p>
            <p class="text-md">Total Interest Earned: <span id="totalInterest" class="font-bold"></span></p>
        </div>

        <div id="errorContainer" class="mt-4 p-3 bg-red-100 rounded-lg border border-red-300 text-red-700 text-center hidden">
            <p id="errorMessage" class="text-sm"></p>
        </div>

        <div id="chartContainer" class="mt-8 p-4 bg-white rounded-lg shadow-md hidden">
            <canvas id="compoundInterestChart"></canvas>
        </div>
    </div>

    <script>
        // Get references to DOM elements
        const currencyUSD_Btn = document.getElementById('currencyUSD');
        const currencyGBP_Btn = document.getElementById('currencyGBP');
        const currencyEUR_Btn = document.getElementById('currencyEUR');
        const currencyButtons = document.querySelectorAll('.currency-button');

        const principalInput = document.getElementById('principal');
        const rateInput = document.getElementById('rate');
        const compoundingSelect = document.getElementById('compounding');
        const yearsInput = document.getElementById('years');
        const contributionAmountInput = document.getElementById('contributionAmount');
        const contributionFrequencySelect = document.getElementById('contributionFrequency');
        const adjustInflationCheckbox = document.getElementById('adjustInflation');
        const inflationRateInput = document.getElementById('inflationRate');
        const inflationRateContainer = document.getElementById('inflationRateContainer');

        const saveScenarioBtn = document.getElementById('saveScenarioBtn');
        const loadScenarioBtn = document.getElementById('loadScenarioBtn');

        const calculateBtn = document.getElementById('calculateBtn');
        const resultContainer = document.getElementById('resultContainer');
        const resultDisplay = document.getElementById('result');
        const totalContributionsDisplay = document.getElementById('totalContributions');
        const totalInterestDisplay = document.getElementById('totalInterest');
        const errorContainer = document.getElementById('errorContainer');
        const errorMessageDisplay = document.getElementById('errorMessage');

        const chartContainer = document.getElementById('chartContainer');
        const compoundInterestChartCanvas = document.getElementById('compoundInterestChart');

        let currentCurrencySymbol = '$';
        let myChart;

        // Function to update the active currency button styling
        function updateActiveCurrencyButton(selectedButton) {
            currencyButtons.forEach(button => {
                button.classList.remove('active', 'bg-blue-600', 'text-white');
                button.classList.add('border-blue-400', 'text-blue-700', 'hover:bg-blue-100');
            });
            selectedButton.classList.add('active', 'bg-blue-600', 'text-white');
            selectedButton.classList.remove('border-blue-400', 'text-blue-700', 'hover:bg-blue-100');
        }

        // Function to toggle visibility of inflation rate input
        function toggleInflationRateInput() {
            if (adjustInflationCheckbox.checked) {
                inflationRateContainer.classList.remove('hidden');
            } else {
                inflationRateContainer.classList.add('hidden');
            }
            calculateCompoundInterest();
        }

        // Function to calculate compound interest with contributions and inflation adjustment
        function calculateCompoundInterest() {
            resultContainer.classList.add('hidden');
            errorContainer.classList.add('hidden');
            chartContainer.classList.add('hidden');

            const P = parseFloat(principalInput.value);
            const r = parseFloat(rateInput.value) / 100;
            const n_c = parseInt(compoundingSelect.value);
            const t = parseFloat(yearsInput.value);
            const PMT = parseFloat(contributionAmountInput.value);
            const n_p = parseInt(contributionFrequencySelect.value);
            const adjustForInflation = adjustInflationCheckbox.checked;
            const inflationRate = parseFloat(inflationRateInput.value) / 100;

            if (isNaN(P) || isNaN(r) || isNaN(n_c) || isNaN(t) || isNaN(PMT) || isNaN(n_p) ||
                P < 0 || r < 0 || n_c <= 0 || t <= 0 || PMT < 0 || (t > 150)) { // Added a max year check
                errorMessageDisplay.textContent = 'Please enter valid positive numbers for Starting Amount, Interest Rate, Compounding Frequency, and Years (max 150). Contribution amount can be zero.';
                errorContainer.classList.remove('hidden');
                return;
            }

            if (adjustForInflation && (isNaN(inflationRate) || inflationRate < 0)) {
                errorMessageDisplay.textContent = 'Please enter a valid non-negative number for Yearly Inflation Rate when adjusting for inflation.';
                errorContainer.classList.remove('hidden');
                return;
            }

            const yearsLabels = [];
            const futureValuesAdjusted = [];
            const futureValuesNominal = [];

            let totalContributionsMade = 0;
            let currentNominalPrincipal = P; // Tracks principal + contributions over time, nominally

            for (let year = 0; year <= t; year++) {
                yearsLabels.push(year);

                // Calculate future value of principal for the current year (nominal)
                let principalFV = P * Math.pow((1 + r / n_c), (n_c * year));

                // Calculate future value of contributions for the current year (nominal)
                let contributionsFV = 0;
                if (PMT > 0 && n_p > 0) {
                    const i_p = r / n_p;
                    const N_p = n_p * year;

                    if (i_p === 0) {
                        contributionsFV = PMT * N_p;
                    } else {
                        contributionsFV = PMT * ((Math.pow((1 + i_p), N_p) - 1) / i_p);
                    }
                }
                
                let currentNominalFutureValue = principalFV + contributionsFV;
                futureValuesNominal.push(parseFloat(currentNominalFutureValue.toFixed(2)));

                let currentAdjustedFutureValue = currentNominalFutureValue;
                if (adjustForInflation && inflationRate >= 0) {
                    if (inflationRate !== 0) {
                        currentAdjustedFutureValue = currentNominalFutureValue / Math.pow((1 + inflationRate), year);
                    }
                }
                futureValuesAdjusted.push(parseFloat(currentAdjustedFutureValue.toFixed(2)));
            }
            
            // Calculate total contributions made
            totalContributionsMade = PMT * n_p * t; // This is the total amount put in over time.

            // Final values
            const finalFutureValueAdjusted = futureValuesAdjusted[futureValuesAdjusted.length - 1];
            const finalFutureValueNominal = futureValuesNominal[futureValuesNominal.length - 1];

            const calculatedTotalInterest = finalFutureValueNominal - P - totalContributionsMade;


            resultDisplay.textContent = `${currentCurrencySymbol}${finalFutureValueAdjusted.toFixed(2)}`;
            totalContributionsDisplay.textContent = `${currentCurrencySymbol}${totalContributionsMade.toFixed(2)}`;
            totalInterestDisplay.textContent = `${currentCurrencySymbol}${calculatedTotalInterest.toFixed(2)}`;
            resultContainer.classList.remove('hidden');

            renderChart(yearsLabels, futureValuesAdjusted, futureValuesNominal, adjustForInflation);
            chartContainer.classList.remove('hidden');
        }

        // Function to render or update the Chart.js graph
        function renderChart(labels, dataAdjusted, dataNominal, showNominalLine) {
            if (myChart) {
                myChart.destroy();
            }

            const datasets = [{
                label: showNominalLine ? `Future Value (Adjusted for Inflation - ${currentCurrencySymbol})` : `Future Value (${currentCurrencySymbol})`,
                data: dataAdjusted,
                borderColor: '#3b82f6',
                backgroundColor: 'rgba(59, 130, 246, 0.2)',
                borderWidth: 2,
                tension: 0.3,
                fill: true,
                pointRadius: 3,
                pointBackgroundColor: '#1e40af'
            }];

            if (showNominalLine) {
                datasets.push({
                    label: `Future Value (Nominal - ${currentCurrencySymbol})`,
                    data: dataNominal,
                    borderColor: '#ef4444',
                    backgroundColor: 'rgba(239, 68, 68, 0.2)',
                    borderWidth: 2,
                    tension: 0.3,
                    fill: false,
                    pointRadius: 3,
                    pointBackgroundColor: '#b91c1c'
                });
            }

            myChart = new Chart(compoundInterestChartCanvas, {
                type: 'line',
                data: {
                    labels: labels,
                    datasets: datasets
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    plugins: {
                        legend: {
                            display: true,
                            position: 'top',
                            labels: {
                                font: {
                                    family: 'Inter',
                                    size: 14
                                },
                                color: '#374151'
                            }
                        },
                        tooltip: {
                            callbacks: {
                                label: function(context) {
                                    let label = context.dataset.label || '';
                                    if (label) {
                                        label += ': ';
                                    }
                                    if (context.parsed.y !== null) {
                                        label += `${currentCurrencySymbol}${context.parsed.y.toFixed(2)}`;
                                    }
                                    return label;
                                }
                            },
                            titleFont: {
                                family: 'Inter'
                            },
                            bodyFont: {
                                family: 'Inter'
                            }
                        }
                    },
                    scales: {
                        x: {
                            title: {
                                display: true,
                                text: 'Year',
                                font: {
                                    family: 'Inter',
                                    size: 14,
                                    weight: 'bold'
                                },
                                color: '#4b5563'
                            },
                            ticks: {
                                font: {
                                    family: 'Inter'
                                },
                                color: '#4b5563'
                            },
                            grid: {
                                color: '#e5e7eb'
                            }
                        },
                        y: {
                            title: {
                                display: true,
                                text: `Value (${currentCurrencySymbol})`,
                                font: {
                                    family: 'Inter',
                                    size: 14,
                                    weight: 'bold'
                                },
                                color: '#4b5563'
                            },
                            ticks: {
                                callback: function(value, index, ticks) {
                                    return `${currentCurrencySymbol}${value.toFixed(0)}`;
                                },
                                font: {
                                    family: 'Inter'
                                },
                                color: '#4b5563'
                            },
                            grid: {
                                color: '#e5e7eb'
                            }
                        }
                    }
                }
            });
        }

        // --- Save/Load Scenario Functions ---
        const saveScenario = () => {
            const scenario = {
                principal: principalInput.value,
                rate: rateInput.value,
                compounding: compoundingSelect.value,
                years: yearsInput.value,
                contributionAmount: contributionAmountInput.value,
                contributionFrequency: contributionFrequencySelect.value,
                adjustInflation: adjustInflationCheckbox.checked,
                inflationRate: inflationRateInput.value,
                currencySymbol: currentCurrencySymbol
            };
            try {
                localStorage.setItem('compoundInterestScenario', JSON.stringify(scenario));
                alert('Scenario saved successfully!');
            } catch (e) {
                alert('Failed to save scenario. Storage might be full or blocked by browser settings.');
            }
        };

        const loadScenario = () => {
            try {
                const savedScenario = localStorage.getItem('compoundInterestScenario');
                if (savedScenario) {
                    const scenario = JSON.parse(savedScenario);
                    principalInput.value = scenario.principal;
                    rateInput.value = scenario.rate;
                    compoundingSelect.value = scenario.compounding;
                    yearsInput.value = scenario.years;
                    contributionAmountInput.value = scenario.contributionAmount;
                    contributionFrequencySelect.value = scenario.contributionFrequency;
                    adjustInflationCheckbox.checked = scenario.adjustInflation;
                    inflationRateInput.value = scenario.inflationRate;

                    // Restore currency button state
                    const currencyBtnToActivate = document.querySelector(`.currency-button[data-currency="${scenario.currencySymbol}"]`);
                    if (currencyBtnToActivate) {
                        currentCurrencySymbol = scenario.currencySymbol;
                        updateActiveCurrencyButton(currencyBtnToActivate);
                    }

                    toggleInflationRateInput(); // Adjust visibility of inflation rate input
                    calculateCompoundInterest(); // Recalculate with loaded values
                    alert('Scenario loaded successfully!');
                } else {
                    alert('No saved scenario found.');
                }
            } catch (e) {
                alert('Failed to load scenario. Data might be corrupted.');
            }
        };


        // --- Event Listeners ---
        currencyUSD_Btn.addEventListener('click', () => {
            currentCurrencySymbol = '$';
            updateActiveCurrencyButton(currencyUSD_Btn);
            calculateCompoundInterest();
        });
        currencyGBP_Btn.addEventListener('click', () => {
            currentCurrencySymbol = '£';
            updateActiveCurrencyButton(currencyGBP_Btn);
            calculateCompoundInterest();
        });
        currencyEUR_Btn.addEventListener('click', () => {
            currentCurrencySymbol = '€';
            updateActiveCurrencyButton(currencyEUR_Btn);
            calculateCompoundInterest();
        });

        adjustInflationCheckbox.addEventListener('change', toggleInflationRateInput);
        inflationRateInput.addEventListener('input', calculateCompoundInterest);

        saveScenarioBtn.addEventListener('click', saveScenario);
        loadScenarioBtn.addEventListener('click', loadScenario);

        calculateBtn.addEventListener('click', calculateCompoundInterest);
        principalInput.addEventListener('input', calculateCompoundInterest);
        rateInput.addEventListener('input', calculateCompoundInterest);
        compoundingSelect.addEventListener('change', calculateCompoundInterest);
        yearsInput.addEventListener('input', calculateCompoundInterest);
        contributionAmountInput.addEventListener('input', calculateCompoundInterest);
        contributionFrequencySelect.addEventListener('change', calculateCompoundInterest);


        // Initial setup on page load
        updateActiveCurrencyButton(currencyUSD_Btn);
        toggleInflationRateInput();
        calculateCompoundInterest();
    </script>
</body>
</html>
