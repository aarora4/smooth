from flask import Flask, request, jsonify
import time

app = Flask(__name__)

#sensitivity
eps = 0


isActive = False
awaitingIntialize = False
updateAvailable = False
currentData = {}
update = {}
currentItem = None
weight = [0]
isDone = False
updateCalls = 0


@app.route("/")
def home():
    return "Hello, World!"

# Initialize the backend - Attempt to make/Allow connection to the App API
# Expect data of the form {"weight" : value}
@app.route("/inactive/initialize/scale", methods = ["POST"])
def initializeScale():
    global updateAvailable
    global update
    global currentData
    global weight
    global awaitingIntialize

    updateAvailable = False
    update = {}
    currentData = {}
    #weight = [request.json["weight"]]
    weight = [float(request.data)]

    awaitingIntialize = True
    return jsonify('awaiting responses'), 202

@app.route("/inactive/initialize/alexa", methods = ["POST"])
def initializeAlexa():
    return 'service not available', 404

@app.route("/inactive/confirm_activity", methods = ["GET"])
def confirm_activity():
    if isActive:
        return 'fine', 200
    else:
        return 'service not available', 404

# Send lastest dataset to app
@app.route("/active/appUpdate", methods = ['GET'])
def appUpdate():
    global update
    global awaitingIntialize
    global updateAvailable
    global isActive
    global updateCalls

    updateCalls += 1

    if awaitingIntialize:
        awaitingIntialize = False
        isActive = True
    elif not awaitingIntialize and not isActive:
        return jsonify({"updateAvailable" : False, "serviceAvailable" : False, "update" : None}), 404

    if not updateAvailable:
        return jsonify({"updateAvailable" : False, "serviceAvailable" : True, "update" : None}), 200
    else:
        payload = jsonify({"updateAvailable" : True, "serviceAvailable" : True, "update" : update})

        updateAvailable = False
        update = {}

        return payload, 200


# Expect data of the form {"weight" : value}
# Receive Weight
@app.route("/active/receiveWeight", methods = ['POST'])
def receiveWeight():

    if isDone:
        return "done", 200

    global weight
    global updateAvailable
    global isActive
    global currentItem
    global update
    global currentData

    if not isActive:
        return jsonify('service not available'), 404

    if currentItem is None:
        return "Nothing Yet", 200
    else:
        weight.append(float(request.data))

        weightChange = weight[-1] - weight[-2]

        if currentItem not in currentData:
            updateAvailable = True
            update[currentItem] = weightChange
            currentData[currentItem] = weightChange
        elif abs(weightChange) > eps:
            updateAvailable = True
            currentData[currentItem] += weightChange
            update[currentItem] = currentData[currentItem]


        if len(weight) > 100:
            weight = weight[:-10]

        return currentItem, 200


#Set Current currentItem
# Expect data of the form {"currentItem" : value}
@app.route("/active/currentItem", methods = ['POST'])
def setCurrentItem():
    global currentData
    global currentItem

    if not isActive:
        return jsonify('service not available'), 404

    if request.json["currentItem"] is not None:
        currentItem = request.json["currentItem"]

    return "fine", 200


@app.route("/active/getCurrentItem", methods = ['GET'])
def getCurrentItem():
    if not isActive:
        return jsonify('service not available'), 404
    else:
        return currentItem, 200


@app.route("/test/getData", methods = ['GET'])
def getData():
    data = {}
    data["isActive"] = isActive
    data["awaitingIntialize"] = awaitingIntialize
    data["updateAvailable"] = updateAvailable
    data["currentData"] = currentData
    data["update"] = update
    data["currentItem"] = currentItem
    data["weight"] = weight
    data["isDone"] = isDone
    data["updateCalls"] = updateCalls

    return jsonify(data), 200


@app.route("/active/getItemList", methods = ['GET'])
def getItemList():
    return jsonify({"ingredientList" : currentData.keys()}), 200


@app.route("/active/done", methods = ['POST'])
def makeDone():
    global isDone
    isDone = True
    return "fine", 200


@app.route("/test/resetState", methods = ['GET'])
def resetData():
    global updateAvailable
    global update
    global currentData
    global weight
    global awaitingIntialize
    global currentItem
    global isActive
    global isDone

    isDone = False
    updateAvailable = False
    update = {}
    currentData = {}
    weight = 0
    awaitingIntialize = False
    currentItem = None
    isActive = False

    return "fine", 200

if __name__ == '__main__':
    app.run()
