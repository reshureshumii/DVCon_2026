import cv2
import numpy as np
from ultralytics import YOLO
from task_config import get_task_relevance, SCORE_THRESHOLD

# Load pretrained YOLOv8 model (downloads automatically on first run ~6MB)
model = YOLO("yolov8n.pt")


def run_detection(image_path, task_name):
    """
    Run YOLOv8 on image, compute Score1 = Detection Confidence x Task Relevance.

    Returns:
        annotated_img   : numpy array with bounding boxes drawn
        top2            : list of top 2 candidates forwarded to FPGA (Stage 2)
        passed_filter   : all objects that passed Stage 1 threshold
        dropped         : objects filtered out in Stage 1
    """
    img = cv2.imread(image_path)
    if img is None:
        raise ValueError(f"Could not read image: {image_path}")

    results = model(img, verbose=False)[0]

    all_detections = []
    for box in results.boxes:
        cls_id     = int(box.cls[0])
        class_name = model.names[cls_id]
        confidence = float(box.conf[0])
        x1, y1, x2, y2 = map(int, box.xyxy[0])

        task_relevance, tier = get_task_relevance(task_name, class_name)
        score1 = round(confidence * task_relevance, 4)

        all_detections.append({
            "class":          class_name,
            "confidence":     round(confidence, 4),
            "task_relevance": task_relevance,
            "tier":           tier,
            "score1":         score1,
            "bbox":           [x1, y1, x2, y2],
        })

    # Sort by Score1 descending
    all_detections.sort(key=lambda x: x["score1"], reverse=True)

    # Stage 1 filtering
    passed_filter = [d for d in all_detections if d["score1"] >= SCORE_THRESHOLD]
    dropped       = [d for d in all_detections if d["score1"] <  SCORE_THRESHOLD]

    # Top 2 candidates forwarded to FPGA
    top2 = passed_filter[:2]

    # ── Draw bounding boxes ──────────────────────────────────────────────────
    annotated = img.copy()

    for det in dropped:
        x1, y1, x2, y2 = det["bbox"]
        cv2.rectangle(annotated, (x1, y1), (x2, y2), (80, 80, 80), 1)   # grey = dropped
        cv2.putText(annotated, f"{det['class']} [DROPPED]",
                    (x1, y1 - 4), cv2.FONT_HERSHEY_SIMPLEX, 0.4, (80, 80, 80), 1)

    for i, det in enumerate(passed_filter):
        x1, y1, x2, y2 = det["bbox"]

        if i == 0:
            color = (0, 200, 0)      # Primary   – green
            label_prefix = "[PRIMARY]"
        elif i == 1:
            color = (255, 140, 0)    # Alt       – orange
            label_prefix = "[ALT]"
        else:
            color = (180, 180, 0)    # Other passed – yellow
            label_prefix = ""

        cv2.rectangle(annotated, (x1, y1), (x2, y2), color, 2)
        label = f"{label_prefix} {det['class']} S1:{det['score1']}"
        lsz, _ = cv2.getTextSize(label, cv2.FONT_HERSHEY_SIMPLEX, 0.45, 1)
        cv2.rectangle(annotated, (x1, y1 - 16), (x1 + lsz[0], y1), color, -1)
        cv2.putText(annotated, label, (x1, y1 - 3),
                    cv2.FONT_HERSHEY_SIMPLEX, 0.45, (255, 255, 255), 1)

    return annotated, top2, passed_filter, dropped
