
# OTel API
from opentelemetry import metrics as metric_api

# OTel SDK
from opentelemetry.sdk.metrics.export import (
    ConsoleMetricExporter,
    PeriodicExportingMetricReader,
    MetricReader,
)
from opentelemetry.metrics import Counter, Histogram, ObservableGauge
from opentelemetry.sdk.metrics import MeterProvider

def create_metrics_pipeline(export_interval: int) -> MetricReader:
    console_exporter = ConsoleMetricExporter()
    reader = PeriodicExportingMetricReader(
        exporter=console_exporter,
        export_interval_millis=export_interval
    )
    return reader

def create_meter(name: str, version: str) -> metric_api.Meter:
    # configure provider
    metric_reader = create_metrics_pipeline(5000)
    provider = MeterProvider(
        metric_readers=[metric_reader],
    )

    # obtain meter
    metric_api.set_meter_provider(provider)
    meter = metric_api.get_meter(name, version)
    return meter

def create_request_instruments(meter: metric_api.Meter) -> dict[str, metric_api.Instrument]:
    index_counter = meter.create_counter(
        name="index_called_total",
        unit="request",
        description="Total amount of requests to /"
    )

    add_counter = meter.create_counter(
        name="add_called_total",
        unit="request",
        description="Total amount of requests to /add"
    )

    delete_counter = meter.create_counter(
        name="delete_called_total",
        unit="request",
        description="Total amount of requests to /delete"
    )

    error_rate = meter.create_counter( 
        name="error_rate",
        unit="request",
        description="rate of failed requests"
    ) 

    request_latency = meter.create_histogram( 
        name="http.server.request.duration", 
        unit="s", 
        description="latency for a request to be served",
    )

    instruments = {
        "index_counter": index_counter,
        "add_counter": add_counter,
        "delete_counter": delete_counter,
        "error_rate": error_rate,
        "http.server.request.duration": request_latency
    }
    return instruments