# SPDX-FileCopyrightText: 2022 Nicolo Santilio <nicolo.santilio@outlook.com>

# SPDX-License-Identifier: MIT

# https://github.com/fenix-hub/unirest-gdscript/blob/main/addons/unirest-gdscript/src/utils/operations.gd

extends RefCounted
class_name JsonClassConverter


static func json_string_to_class(json_string: String, _class: Object) -> Object:
	var json: JSON = JSON.new()
	if json.parse(json_string) == OK:
		return json_to_class(json.data, _class)
	return _class

static func json_to_class(json: Dictionary, _class: Object) -> Object:
	var properties: Array = _class.get_property_list()
	for key in json.keys():
		for property in properties:
			if property.name == key and property.usage >= 4096:
				if String(property["class_name"]).is_empty():
					_class.set(key, json[key])
				elif property["class_name"] in ["RefCounted", "Object"]:
					_class.set(key, json_to_class(json[key], _class.get(key)))
				break
	return _class

static func class_to_json_string(_class: Object) -> String:
	return JSON.stringify(class_to_json(_class))

static func class_to_json(_class: Object) -> Dictionary:
	var dictionary: Dictionary = {}
	var properties: Array = _class.get_property_list()
	for property in properties:
		if not property["name"].empty() and property.usage >= (1 << 13):
			if (property["class_name"] in ["Reference", "Object"] and property["type"] == 17):
				dictionary[property.name] = class_to_json(_class.get(property.name))
			else:
				dictionary[property.name] = _class.get(property.name)
		if not property["hint_string"].empty() and property.usage >= (1 << 13):
			if (property["class_name"] in ["Reference", "Object"] and property["type"] == 17):
				dictionary[property.hint_string] = class_to_json(_class.get(property.name))
			else:
				dictionary[property.hint_string] = _class.get(property.name)
	return dictionary
