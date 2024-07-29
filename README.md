#  Auditif

Auditif, pronounced "aw-dee-teef", is a MacOS app that utilizes Whisper to perform speech-to-text transcription. 

## Running 
In order to run the app, download the model and encoder files from [huggingface](https://huggingface.co/ggerganov/whisper.cpp/tree/main).

The model referenced in the code is `ggml-small.en.bin`; the CoreML file (`ggml-small.en-encoder.modelc`) should be added to the directory as well.

## Development Priorities 

* Diarization
* Streaming Transcription 
* Adding drivers for transcribing from input + output 
