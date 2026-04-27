import whisper
import os
import torch
import librosa
import matplotlib.pyplot as plt

def transcribe_and_visualize(audio_path):
    device = "cuda" if torch.cuda.is_available() else "cpu"
    model = whisper.load_model("base", device=device)
    result = model.transcribe(audio_path)
    print(f"Текст: {result['text']}")
    y, sr = librosa.load(audio_path)
    plt.figure(figsize=(10, 4))
    D = librosa.amplitude_to_db(np.abs(librosa.stft(y)), ref=np.max)
    librosa.display.specshow(D, sr=sr, x_axis='time', y_axis='hz')
    plt.colorbar(format='%+2.0f dB')
    plt.title('Spectrogram')
    plt.savefig('spectrogram.png')
    with open("results.txt", "w", encoding="utf-8") as f:
        f.write(f"{audio_path}: {result['text']}")

if __name__ == "__main__":
    print("Whisper module loaded.")
