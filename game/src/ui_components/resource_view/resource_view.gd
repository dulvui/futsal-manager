# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

class_name ResourceView
extends GridContainer


func setup(resource: Resource) -> void:
	for child: Node in get_children():
		child.queue_free()
	
	for property: Dictionary in resource.get_property_list():
		if property.usage == Const.CUSTOM_PROPERTY_EXPORT:
			var property_name: String = property.name

			# ignore hidden properties and id
			if not property_name.contains("_") or property_name != "id":
				var variant: Variant = resource.get(property_name)
				var value: String = str(variant)

				if variant is Dictionary and "date" in property_name:
					value =	FormatUtil.format_date(variant)

				var name_label: Label = Label.new()
				ThemeUtil.bold(name_label)
				name_label.text = property_name.to_upper()
				add_child(name_label)

				var value_label: Label = Label.new()
				value_label.text = value
				add_child(value_label)

