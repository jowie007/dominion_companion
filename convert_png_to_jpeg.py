import os
from PIL import Image

def convert_png_to_jpg(source_folder):
    parent_folder = os.path.dirname(source_folder)
    new_folder = os.path.join(parent_folder, 'converted_images')

    if not os.path.exists(new_folder):
        os.makedirs(new_folder)

    for subdir, _, files in os.walk(source_folder):
        for file in files:
            if file.lower().endswith('.png'):
                file_path = os.path.join(subdir, file)

                img = Image.open(file_path)

                rgb_img = img.convert('RGB')

                relative_path = os.path.relpath(subdir, source_folder)
                new_subdir = os.path.join(new_folder, relative_path)
                if not os.path.exists(new_subdir):
                    os.makedirs(new_subdir)

                new_file_name = os.path.splitext(file)[0] + '.jpg'
                new_file_path = os.path.join(new_subdir, new_file_name)

                rgb_img.save(new_file_path, 'JPEG')

                print(f'Converted {file_path} to {new_file_path}')

source_folder = 'assets/cards/full'
convert_png_to_jpg(source_folder)
