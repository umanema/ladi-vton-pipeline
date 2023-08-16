import cv2
import os, os.path
import numpy as np

src_folder_person = "./input/person"
src_folder_cloth = "./input/cloth"

dest_folder_person = "./resize/person"
dest_folder_cloth = "./resize/cloth"

valid_images = [".jpg",".png",".jpeg"]

height = 1024
width = 768

def resize_and_save(img, dest_folder, filename):
    print(filename)
    blank_img = np.zeros((height,width,3), np.uint8)
    blank_img[:,:] = (255,255,255)
    final_img = blank_img.copy()
    
    h, w, c = img.shape
    
    if h / w > 1.3333:
        new_width=int(w*(height/h))
        img_resize = cv2.resize(img, dsize =(new_width, height), interpolation=cv2.INTER_CUBIC)
        x_offset = int((width - w*(height/h))/2)
        final_img[0:height, x_offset:x_offset+new_width] = img_resize.copy()
    else:
        new_height=int(h*(width/w))
        img_resize = cv2.resize(img, dsize =(width, new_height), interpolation=cv2.INTER_CUBIC)
        y_offset = int((height - new_height)/2)
        final_img[y_offset:y_offset+new_height, 0:width] = img_resize

    output_path = os.path.join(dest_folder, filename)
    cv2.imwrite(output_path, final_img)

def resize(src_folder, dest_folder, name):
    for f in os.listdir(src_folder):
        ext = os.path.splitext(f)[1]
        if ext.lower() not in valid_images:
            continue
        else:
            img = cv2.imread(os.path.join(src_folder,f),cv2.IMREAD_UNCHANGED)
            resize_and_save(img, dest_folder, name + ".jpg")

resize(src_folder_person, dest_folder_person, "person")
resize(src_folder_cloth, dest_folder_cloth, "cloth")

        