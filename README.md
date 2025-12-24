# GLM-4.5-Air

A step-by-step guide to running **GLM-4.5-Air** (IQ1_M quant) locally using **Ollama**.

> [!NOTE]
> GLM-4.5-Air is a **Mixture-of-Experts (MoE)** model.  
> Even heavily quantized variants require significantly more memory than dense models of similar file size.

---

## System Requirements

| System Memory | Status |
|---------------|--------|
| 32–36 GB      | ⚠️ Loads with heavy swap; extremely slow and not recommended |
| 48 GB         | ⚠️ Loads, but KV cache and performance are limited |
| 64 GB         | ✅ Usable for testing |
| 96 GB+        | ✅ Recommended for smooth usage |

> ⚠️ Loading this model on insufficient memory may lead to crashes or extremely slow performance.

---

## Download

Clone this repository:

```bash
git clone https://github.com/use-solace/glm-4.5-air.git
cd glm-4.5-air/
```

Run the **download script**:

```bash
bash download.sh
```

The model will be downloaded to:

```
~/glm-4.5-air-model/
```

---

## Create Model with Ollama

Once the model is downloaded, navigate to the destination:

```bash
cd ~/glm-4.5-air-model/
```

Ensure [Modelfile](Modelfile) exists in the directory:

```bash
ls Modelfile
```

> ⚠️ If [Modelfile](Modelfile) does not exist in the directory, run `mv ~/glm-4.5-air-ollama/Modelfile ./`

Create the model in Ollama:

```bash
ollama create glm-4.5-air -f Modelfile
```

---

## Usage

Run the model:

```bash
ollama run glm-4.5-air
```

You can pass prompts interactively:

```text
>>> Hello, who am I speaking to?
```

---

## Notes

* **Memory:** IQ1_M is heavily quantized but still requires **~64 GB minimum for usable performance**.
* **Disk:** Ensure at least **60 GB free** for downloading and unpacking.
* **Slow systems:** On <64 GB RAM, responses may be extremely slow.
* **Updates:** Always check Hugging Face for newer quantizations or patches.

---

## License

Apache License 2.0

This repository contains configuration, Modelfile templates, and instructions only.
Do **not** redistribute GGUF model files; link to Hugging Face instead:

[GLM-4.5-Air GGUF on Hugging Face](https://huggingface.co/unsloth/GLM-4.5-Air-GGUF)
