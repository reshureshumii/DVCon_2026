# Task-Based Object Prioritization System (COCO Dataset)
# Three tiers:
#   High Priority     = 0.9  (exact match)
#   Medium Priority   = 0.7 / 0.5  (related objects)
#   Semantic Fallback = 0.4  (human-reasoning alternatives)
#   Default           = 0.2  (all other COCO classes)

TASK_OBJECT_MAP = {
    "1. Step on something": {
        "high":     {"bench": 0.9},
        "medium":   {"chair": 0.7, "couch": 0.5, "bed": 0.5},
        "fallback": {"suitcase": 0.4, "skateboard": 0.4, "book": 0.4},
    },
    "2. Sit comfortably": {
        "high":     {"chair": 0.9},
        "medium":   {"couch": 0.7, "bed": 0.5, "bench": 0.5},
        "fallback": {"dining table": 0.4, "toilet": 0.4, "suitcase": 0.4},
    },
    "3. Place flowers": {
        "high":     {"vase": 0.9},
        "medium":   {"potted plant": 0.7, "bowl": 0.5},
        "fallback": {"cup": 0.4, "wine glass": 0.4, "bottle": 0.4},
    },
    "4. Get potatoes out of fire": {
        "high":     {"spoon": 0.9},
        "medium":   {"fork": 0.7, "knife": 0.5, "bowl": 0.5},
        "fallback": {"scissors": 0.4, "tongs": 0.4},
    },
    "5. Water plant": {
        "high":     {"potted plant": 0.9},
        "medium":   {"bottle": 0.7, "cup": 0.5, "bowl": 0.5},
        "fallback": {"wine glass": 0.4, "vase": 0.4},
    },
    "6. Get the lemon out of the tea": {
        "high":     {"spoon": 0.9},
        "medium":   {"fork": 0.7, "cup": 0.5},
        "fallback": {"knife": 0.4, "chopsticks": 0.4},
    },
    "7. Dig a hole": {
        "high":     {},
        "medium":   {"knife": 0.7, "spoon": 0.5, "bowl": 0.5, "cup": 0.5},
        "fallback": {"fork": 0.4, "scissors": 0.4, "baseball bat": 0.4},
    },
    "8. Open a bottle of beer": {
        "high":     {"bottle": 0.9},
        "medium":   {"knife": 0.7, "spoon": 0.5},
        "fallback": {"fork": 0.4, "scissors": 0.4},
    },
    "9. Open parcel": {
        "high":     {"knife": 0.9, "scissors": 0.9},
        "medium":   {"fork": 0.7, "spoon": 0.5},
        "fallback": {"bottle": 0.4, "pen": 0.4},
    },
    "10. Serve wine": {
        "high":     {"wine glass": 0.9},
        "medium":   {"cup": 0.7, "bottle": 0.5},
        "fallback": {"bowl": 0.4, "vase": 0.4},
    },
    "11. Pour sugar": {
        "high":     {"cup": 0.9},
        "medium":   {"bowl": 0.7, "spoon": 0.5, "bottle": 0.5},
        "fallback": {"wine glass": 0.4, "vase": 0.4},
    },
    "12. Smear butter": {
        "high":     {"knife": 0.9},
        "medium":   {"spoon": 0.7},
        "fallback": {"fork": 0.4, "scissors": 0.4},
    },
    "13. Extinguish fire": {
        "high":     {},
        "medium":   {"bottle": 0.7, "cup": 0.5, "bowl": 0.5},
        "fallback": {"vase": 0.4, "fire hydrant": 0.4},
    },
    "14. Pound carpet": {
        "high":     {"baseball bat": 0.9},
        "medium":   {"tennis racket": 0.7, "skateboard": 0.5},
        "fallback": {"bottle": 0.4, "umbrella": 0.4},
    },
}

TASK_LIST = list(TASK_OBJECT_MAP.keys())
DEFAULT_WEIGHT = 0.2
SCORE_THRESHOLD = 0.08  # Objects below this Score1 are filtered out in Stage 1


def get_task_relevance(task_name, object_class):
    """Return (weight, tier_label) for a detected object given a task."""
    task = TASK_OBJECT_MAP.get(task_name, {})
    obj = object_class.lower()

    high     = task.get("high", {})
    medium   = task.get("medium", {})
    fallback = task.get("fallback", {})

    if obj in high:
        return high[obj], "High"
    if obj in medium:
        return medium[obj], "Medium"
    if obj in fallback:
        return fallback[obj], "Semantic Fallback"
    return DEFAULT_WEIGHT, "Default"
