# ChipUp – Task-Aware Object Detection
## DVCon India 2026 | Team ID: 188

### Setup (one time)

```bash
pip install -r requirements.txt
```

### Run

```bash
python app.py
```

Then open your browser at: http://localhost:5000

### How it works

1. Upload any image
2. Select one of the 14 tasks
3. YOLOv8 detects all objects (pretrained on COCO — no training needed)
4. Score₁ = Detection Confidence × Task Relevance is computed for each object
5. Results shown: annotated image + ranked table

### Folder structure

```
chipup_dvcon/
├── app.py            # Flask server
├── detector.py       # YOLOv8 + scoring
├── task_config.py    # 14 tasks + priority weights
├── requirements.txt
├── templates/
│   └── index.html    # Web UI
└── uploads/          # Created automatically
```

### Team
- Rosiny C A
- Varsha S  
- Reshmi K

Chennai Institute of Technology – Anna University
