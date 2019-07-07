import cv2
import sys
from PIL import Image
import io
import path
import json

borders_skip = 400

cascde = cv2.CascadeClassifier(path)

video_1 = cv2.VideoCapture(0)
work_loop = True
cur_borders = 0
successful_attempt = 0

while work_loop:
    
    ret, borders = video_1.read()

    if cur_borders % borders_skip == 0:
        pil_form = Image.fromarray(borders)
        input = io.BytesIO()
        pil_form.save(input, format='JPEG')
        unt_image = input.getvalue()
        
        return_val = predict.get_prediction(unt_image)
        for j in return_val.payload:
            print(j.display_name)
            if(j.classification.score > 0.3 or j.display_name == "target"):
                print("Done")
                successful_attempt += 1
                if successful_attempt >= 4: work_loop = False
        
        blue = cv2.cvtColor(borders, cv2.COLOR_BGR2GRAY)

        faces = cascde.detectMultiScale(
            blue,
            factor=1.3,
            minimum_neighbors=4,
            minimum_size=(20, 20),
            flags=cv2.CASCADE_SCALE_IMAGE
        )

        for (x_int, y_int, width_int, height_int) in faces:
            cv2.rectangle(borders, (x_int, y_int), (x_int+width_int, y_int+height_int), (0, 255, 0), 2)

        cv2.imshow('Video', borders)

        if cv2.waitKey(1) & 0xFF == ord('q'):
            break

video_1.release()
cv2.destroyAllWindows()
