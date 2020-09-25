// Auto-generated. Do not edit!

// (in-package beginner_tutorials.msg)


"use strict";

const _serializer = _ros_msg_utils.Serialize;
const _arraySerializer = _serializer.Array;
const _deserializer = _ros_msg_utils.Deserialize;
const _arrayDeserializer = _deserializer.Array;
const _finder = _ros_msg_utils.Find;
const _getByteLength = _ros_msg_utils.getByteLength;

//-----------------------------------------------------------

class Num {
  constructor(initObj={}) {
    if (initObj === null) {
      // initObj === null is a special case for deserialization where we don't initialize fields
      this.num = null;
      this.vorname = null;
      this.nachname = null;
      this.alter = null;
    }
    else {
      if (initObj.hasOwnProperty('num')) {
        this.num = initObj.num
      }
      else {
        this.num = 0;
      }
      if (initObj.hasOwnProperty('vorname')) {
        this.vorname = initObj.vorname
      }
      else {
        this.vorname = '';
      }
      if (initObj.hasOwnProperty('nachname')) {
        this.nachname = initObj.nachname
      }
      else {
        this.nachname = '';
      }
      if (initObj.hasOwnProperty('alter')) {
        this.alter = initObj.alter
      }
      else {
        this.alter = 0;
      }
    }
  }

  static serialize(obj, buffer, bufferOffset) {
    // Serializes a message object of type Num
    // Serialize message field [num]
    bufferOffset = _serializer.int64(obj.num, buffer, bufferOffset);
    // Serialize message field [vorname]
    bufferOffset = _serializer.string(obj.vorname, buffer, bufferOffset);
    // Serialize message field [nachname]
    bufferOffset = _serializer.string(obj.nachname, buffer, bufferOffset);
    // Serialize message field [alter]
    bufferOffset = _serializer.uint8(obj.alter, buffer, bufferOffset);
    return bufferOffset;
  }

  static deserialize(buffer, bufferOffset=[0]) {
    //deserializes a message object of type Num
    let len;
    let data = new Num(null);
    // Deserialize message field [num]
    data.num = _deserializer.int64(buffer, bufferOffset);
    // Deserialize message field [vorname]
    data.vorname = _deserializer.string(buffer, bufferOffset);
    // Deserialize message field [nachname]
    data.nachname = _deserializer.string(buffer, bufferOffset);
    // Deserialize message field [alter]
    data.alter = _deserializer.uint8(buffer, bufferOffset);
    return data;
  }

  static getMessageSize(object) {
    let length = 0;
    length += object.vorname.length;
    length += object.nachname.length;
    return length + 17;
  }

  static datatype() {
    // Returns string type for a message object
    return 'beginner_tutorials/Num';
  }

  static md5sum() {
    //Returns md5sum for a message object
    return 'd59150134dddd4be2143129962b51a21';
  }

  static messageDefinition() {
    // Returns full string definition for message
    return `
    int64 num
    string vorname
    string nachname
    uint8 alter
    
    `;
  }

  static Resolve(msg) {
    // deep-construct a valid message object instance of whatever was passed in
    if (typeof msg !== 'object' || msg === null) {
      msg = {};
    }
    const resolved = new Num(null);
    if (msg.num !== undefined) {
      resolved.num = msg.num;
    }
    else {
      resolved.num = 0
    }

    if (msg.vorname !== undefined) {
      resolved.vorname = msg.vorname;
    }
    else {
      resolved.vorname = ''
    }

    if (msg.nachname !== undefined) {
      resolved.nachname = msg.nachname;
    }
    else {
      resolved.nachname = ''
    }

    if (msg.alter !== undefined) {
      resolved.alter = msg.alter;
    }
    else {
      resolved.alter = 0
    }

    return resolved;
    }
};

module.exports = Num;
