"""Download file from S3, encode it and upload the output back to S3."""
import os
import os.path
import subprocess


input_url = os.environ['INPUT_FILE']
output_url = os.environ['OUTPUT_FILE']
input_file = os.path.basename(input_url)
output_file = os.path.basename(output_url)
threads = os.environ['THREADS']

print('Downloading file')
if subprocess.run(['aws', 's3', 'cp', input_url, '.']).returncode > 0:
    raise RuntimeError('Failed to download input file - {}'.format(input_file))

encode_cmd = [
    'ffmpeg', '-v', 'error', '-y', '-threads', threads, '-i', input_file,
    '-pix_fmt', 'yuv420p', '-vf', 'scale=640:360',
    '-c:v', 'libx264', '-profile:v', 'main', '-b:v', '850k', '-bufsize', '1700k', '-g', '250', '-keyint_min', '25',
    '-bf', '0', '-x264opts', 'no-scenecut', '-c:a', 'aac', '-b:a', '96000', '-ac', '2', output_file]
print('Encoding file')
if subprocess.run(encode_cmd).returncode > 0:
    raise RuntimeError('Failed to encode {} to {}'.format(input_file, output_file))

print('Uploading file')
if subprocess.run(['aws', 's3', 'cp', output_file, output_url]).returncode > 0:
    raise RuntimeError('Failed to upload output file {} to {}'.format(output_file, output_url))
