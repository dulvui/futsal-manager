# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

extends Node

const BACKUP_SUFFIX: StringName = ".backup"


func create_backup(path: StringName, file_suffix: StringName) -> StringName:
	var file_path: StringName = path + file_suffix
	print("creating backup for %s..." % file_suffix)
	var backup_path: StringName = path + BACKUP_SUFFIX + file_suffix

	var dir_access: DirAccess = DirAccess.open(file_path.get_base_dir())
	if dir_access:
		dir_access.copy(file_path, backup_path)
		print("creating backup for %s done." % file_path)
	else:
		print("creating backup for %s gone wrong." % file_path)
	return file_path


func restore_backup(path: String, file_suffix: StringName) -> StringName:
	#  first, make sure, path has no suffix
	path = path.replace(file_suffix, "")
	var file_path: StringName = path + file_suffix
	print("restoring backup for %s..." % file_path)
	var backup_path: StringName = path + BACKUP_SUFFIX + file_suffix

	var dir_access: DirAccess = DirAccess.open(file_path.get_base_dir())
	if dir_access:
		dir_access.copy(backup_path, file_path)
		print("restoring backup for %s done." % file_path)
	else:
		print("restoring backup for %s gone wrong." % file_path)
	return backup_path
