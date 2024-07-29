from flask import Flask, jsonify
import socket

app = Flask(__name__)

def mirror(word):
    #     # @todo rules
    # 1. Any lowercase letter must be transformed to be uppercase
    # 2. Any uppercase letter must be transformed to be lowercase
    # 3. Any other character should be left as is
    # 4. A final transformation must be applied so that the whole string is reversed. (’foo’ ⇒ ‘oof’, ‘bar’ ⇒ ‘rab’)ii. It saves the the pair <word, mirroredWord> in a database    return 
    return word

@app.route("/", methods=["GET"])
def index():
    return jsonify({"here":"yes"})

@app.route("/api/health", methods=["GET"])
def route_health():
    return jsonify({"status": "ok"})

@app.route("/api/mirror=<the_word>", methods=["GET"])
def route_mirror(the_word):
    transformed_word = mirror( the_word )
    return jsonify({"transformed": transformed_word})


if __name__ == "__main__":
    app.run(host='0.0.0.0', port=4004)
