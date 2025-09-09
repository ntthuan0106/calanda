from flask import (
    Flask,
    render_template,
    request,
    jsonify,
    redirect,
    url_for,
    make_response,
    Response
)

import logging
import requests
import os
import time

from opentelemetry import trace

from metric_utils import create_meter, create_request_instruments

tracer = trace.get_tracer("todo.tracer")

app = Flask(__name__)
meter = create_meter("app.py", "0.1")
logging.getLogger(__name__)
logging.basicConfig(format='%(levelname)s:%(name)s:%(module)s:%(message)s', level=logging.INFO)

# Set a default external API URL
# Override the default URL if an environment variable is set
app.config['BACKEND_URL'] = 'http://localhost:8080/todos/'
app.config['BACKEND_URL'] = os.getenv('BACKEND_URL', app.config['BACKEND_URL'])

@app.route('/')
def index():
    
    request_instruments['index_counter'].add(1)
    
    backend_url = app.config['BACKEND_URL']
    response = requests.get(backend_url)
    
    logging.info("GET %s/todos/",backend_url)
    
    if response.status_code == 200:
        # Print out the response content
        # print(response.text)
        logging.info("Response: %s", response.text)        
        todos = response.json()
        
    return render_template('index.html', todos=todos)

@app.route('/add', methods=['POST'])
def add():
    
    if request.method == 'POST':
        
        request_instruments['add_counter'].add(1)
        
        with tracer.start_as_current_span("add") as span:
            new_todo = request.form['todo']
            span.set_attribute("todo.value",new_todo)
            logging.info("POST  %s/todos/%s",app.config['BACKEND_URL'],new_todo)
            response = requests.post(app.config['BACKEND_URL']+new_todo)
            
    return redirect(url_for('index'))

@app.route('/delete', methods=['POST'])
def delete():

    if request.method == 'POST':
        
        request_instruments['delete_counter'].add(1)

        with tracer.start_as_current_span("delete") as span:
            delete_todo = request.form['todo']
            span.set_attribute("todo.value", delete_todo)
            logging.info("POST  %s/todos/%s",app.config['BACKEND_URL'],delete_todo)
            print(delete_todo)
            response = requests.delete(app.config['BACKEND_URL']+delete_todo)
            
    return redirect(url_for('index'))


@app.before_request
def before_request_func():
    request.environ["request_start"] = time.time_ns()

@app.after_request
def after_request_func(response: Response) -> Response:
    request_end = time.time_ns()
    duration = (request_end - request.environ["request_start"]) / 1_000_000_000 # convert ns to s
    
    request_instruments["http.server.request.duration"].record(
        duration,
        attributes = {
            "http.request.method": request.method,
            "http.route": request.path,
            "http.response.status_code": response.status_code
        }
    )

    request_instruments["error_rate"].add(1, {
            "http.route": request.path,
            "state": "success" if response.status_code < 400 else "fail",
        }
    )
    return response

if __name__ == '__main__':
    request_instruments = create_request_instruments(meter)
    app.run(host='0.0.0.0')
