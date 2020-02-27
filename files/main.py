from flask import Flask
from flask import request
import json
from io import StringIO
import re
import pandas as pd
import numpy as np


app = Flask(__name__)


def parse(x):
    """
    convert to float pairs, return the raw data otherwise
    """

    y = re.search("\((.*),(.*)\)", x).group(1, 2)

    if y:
        return y[0], y[1]

    return None, None


@app.route('/calculate', methods=['POST'])
def calculate():
    """
    The endpoint that perform the computation
    """

    if not request.get_data():
        return "Missing message in the body of the request.", 501

    try:
        # Ingest the data from the body here, trasform in a Python list
        # of tuples
        stream = [parse(x) for x in StringIO(
            request.get_data().decode('utf-8')).getvalue().split()]

        # Transform the list in a Pandas dataframe, perform the
        # calculation, return the cov matrix in the response converted
        # into a list (should replace the empty list below)
        pd_stream = pd.DataFrame(stream)
        pd_stream = pd_stream[
            (pd.to_numeric(pd_stream[0], errors='coerce').notnull())
            & (pd.to_numeric(pd_stream[1], errors='coerce').notnull())]

        response = np.cov(np.array(pd_stream.values, dtype=float)).tolist()

        return json.dumps(response), 200
    except Exception:
        return "internal error", 500

