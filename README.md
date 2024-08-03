#  Auditif

Auditif, pronounced "aw-dee-teef", is a MacOS app that utilizes Whisper to perform speech-to-text transcription. 

## Setting up models 

In order to run the app, download the model and encoder files from [huggingface](https://huggingface.co/ggerganov/whisper.cpp/tree/main).

The model referenced in the code is `ggml-small.en.bin`; the CoreML file (`ggml-small.en-encoder.modelc`) should be added to the directory as well.

## Building

To build the project, follow these steps:

1. Open the project in Xcode.
2. Select the target you want to build.
3. Go to the "Signing & Capabilities" tab.
4. Set the "Code Signing Identity" to "Sign to Run Locally" or "Don't Code Sign".
5. Remove any provisioning profiles by setting them to "None".
6. Build and run the project.

If you want to run the iOS app on a physical device, you will need to set up your own signing certificates and provisioning profiles.

## Development Priorities 

* Diarization
* Streaming Transcription 
* Adding drivers for transcribing from input + output 
