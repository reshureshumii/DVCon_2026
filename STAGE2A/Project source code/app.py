import os
import base64
import cv2
from flask import Flask, request, jsonify, render_template
from detector import run_detection
from task_config import TASK_LIST

app = Flask(__name__)
UPLOAD_FOLDER = "uploads"
os.makedirs(UPLOAD_FOLDER, exist_ok=True)


def encode_image(img_array):
    _, buffer = cv2.imencode(".jpg", img_array)
    return base64.b64encode(buffer).decode("utf-8")


@app.route("/")
def index():
    return render_template("index.html", tasks=TASK_LIST)


@app.route("/detect", methods=["POST"])
def detect():
    if "image" not in request.files:
        return jsonify({"error": "No image uploaded"}), 400

    task_name = request.form.get("task", "")
    if not task_name:
        return jsonify({"error": "No task selected"}), 400

    image_file = request.files["image"]
    image_path = os.path.join(UPLOAD_FOLDER, image_file.filename)
    image_file.save(image_path)

    try:
        annotated_img, top2, passed_filter, dropped = run_detection(image_path, task_name)
        img_b64 = encode_image(annotated_img)

        return jsonify({
            "image":         img_b64,
            "top2":          top2,
            "passed_filter": passed_filter,
            "dropped":       dropped,
            "task":          task_name,
        })
    except Exception as e:
        return jsonify({"error": str(e)}), 500


if __name__ == "__main__":
    app.run(debug=True, port=5000)
