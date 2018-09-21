---
layout: default
section: graphs
---
<link href="/mg/metricsgraphics.css" rel="stylesheet">
<script src='https://ajax.googleapis.com/ajax/libs/jquery/1.11.1/jquery.min.js'></script>
<script src='https://cdnjs.cloudflare.com/ajax/libs/d3/4.3.0/d3.min.js' charset='utf-8'></script>
<script src="/mg/metricsgraphics.min.js"></script>
<style>
.mg-active-datapoint-container { font-size: small; }
</style>

<div id="glucose-chart" style="width: 640px; height: 200px;"></div>
<div id="insulin-chart" style="width: 640px; height: 200px;"></div>
<div id="hba1c-chart" style="width: 640px; height: 200px;"></div>
<div id="potassium-chart" style="width: 640px; height: 200px;"></div>
<div id="bp-chart" style="width: 640px; height: 200px;"></div>
<div id="weight-chart" style="width: 640px; height: 200px;"></div>

<script>
d3.json('/data/glucose.json', function(data) {
    data = MG.convert.date(data, 'date', '%Y-%m-%dT%H:%M:%SZ');
    MG.data_graphic({
        title: "Glucose",
        data: data,
        animate_on_load: true,
        width: 640,
        height: 200,
        left: 100,
        target: document.getElementById('glucose-chart'),
        x_accessor: 'date',
        y_accessor: 'value',
        y_label: 'mmol/L'
    });
});
d3.json('/data/insulin.json', function(data) {
    for (var i = 0; i < data.length; i++) {
        data[i] = MG.convert.date(data[i], 'date', '%Y-%m-%dT%H:%M:%SZ');
    }
    MG.data_graphic({
        title: "Insulin",
        data: data,
        animate_on_load: true,
        width: 640,
        height: 200,
        left: 100,
        target: '#insulin-chart',
        legend: ['Fast-acting','Bolus'],
        legend_target: '.legend',
        x_accessor: 'date',
        y_accessor: 'value',
        aggregate_rollover: true,
        y_label: 'units'
    });
});
d3.json('/data/hba1c.json', function(data) {
    data = MG.convert.date(data, 'date', '%Y-%m-%dT%H:%M:%SZ');
    MG.data_graphic({
        title: "HbA1c",
        data: data,
        animate_on_load: true,
        width: 640,
        height: 200,
        left: 100,
        target: document.getElementById('hba1c-chart'),
        x_accessor: 'date',
        y_accessor: 'value',
        y_label: 'mmol/mol'
    });
});
d3.json('/data/potassium.json', function(data) {
    data = MG.convert.date(data, 'date', '%Y-%m-%dT%H:%M:%SZ');
    MG.data_graphic({
        title: "Potassium",
        data: data,
        animate_on_load: true,
        width: 640,
        height: 200,
        left: 100,
        target: document.getElementById('potassium-chart'),
        x_accessor: 'date',
        y_accessor: 'value',
        y_label: 'mmol/L'
    });
});
d3.json('/data/weight.json', function(data) {
    data = MG.convert.date(data, 'date', '%Y-%m-%dT%H:%M:%SZ');
    MG.data_graphic({
        title: "Weight",
        data: data,
        animate_on_load: true,
        width: 640,
        height: 200,
        left: 100,
        target: document.getElementById('weight-chart'),
        x_accessor: 'date',
        y_accessor: 'value',
        y_label: 'kgs'
    });
});
d3.json('/data/bp.json', function(data) {
    for (var i = 0; i < data.length; i++) {
        data[i] = MG.convert.date(data[i], 'date', '%Y-%m-%dT%H:%M:%SZ');
    }
    MG.data_graphic({
        title: "Blood pressure",
        data: data,
        animate_on_load: true,
        width: 640,
        height: 200,
        left: 100,
        target: '#bp-chart',
        legend: ['Systolic','Diastolic'],
        legend_target: '.legend',
        x_accessor: 'date',
        y_accessor: 'value',
        aggregate_rollover: true,
        y_label: 'mmHg'
    });
});
</script>
