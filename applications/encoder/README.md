# Encoder

The encoder is a docker image with S3 CLI tools, python3.5 and FFMPEG installed in it. It is built to download a python
script from S3 which docker will run when the container is started.

It is assumed that the script makes use of the environment variables that is passed in, to download the input file
from s3, encode the file using ffmpeg, and upload the output file back to S3.

The following environment variables are exposed...

* JOB_SCRIPT - A S3 URI location of the python script to run and start-up.
* INPUT_FILE - A S3 URI location of the video to encode.
* OUTPUT_FILE - A S3 URI location of where to upload the output to.
* THREADS - How many threads FFMPEG should use (default: 4).
* AWS_ACCESS_KEY_ID - AWS Access Key.
* AWS_SECRET_ACCESS_KEY - AWS Secret Key.
* AWS_DEFAULT_REGION - AWS Region to use.

An example encode script is provided in the repo called 'encode.py'


## Example

Here is a example of how to run the container...

```bash
docker run \
  -e "JOB_SCRIPT=s3://my-scripts/encode.py" \
  -e "INPUT_FILE=s3://my-sources/video.mov" \
  -e "OUTPUT_FILE=s3://my-encodes/video.mp4" \
  -e "AWS_ACCESS_KEY_ID=xxx" -e "AWS_SECRET_ACCESS_KEY=xxx" \
  encoder:1.0.0
```
