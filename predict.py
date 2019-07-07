import os
import sys

from google.cloud import automl_v1beta1
from google.cloud.automl_v1beta1.proto import service_pb2

def get_prediction(details):
  file_client = automl_v1beta1.PredictionServiceClient()
  project_name = 'projects/{}/locations/us-central1/models/{}'.format("cs171" , "ICN45982")
  message = {'image': {'image_bytes': details }}
  reqd_parameters = {}
  response = file_client.predict(project_name, message, reqd_parameters)
  return response

if __name__ == '__main__':
  path_access = sys.argv[1]
  id_file = sys.argv[2]
  id_model = sys.argv[3]

  with open(path_access, 'rb') as ff:
    details = ff.read()

  print get_prediction(details, id_file,  id_model)
