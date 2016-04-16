#!/usr/bin/python3
# encoding: utf-8

import os
import sys

import xdg.DesktopEntry
import xdg.IconTheme


class LauncherItem:
    def __init__(self, name, executable, icon_path=None):
        self.name = name
        self.executable = executable
        self.icon_path = icon_path


APPLICATIONS_DIRECTORY = '/usr/share/applications'


def get_applications_in_directory(directory):
    for entry in os.listdir(directory):
        desktop_path = os.path.join(directory, entry)
        if entry.endswith('.desktop') and os.path.isfile(path):
            desktop_entry = xdg.DesktopEntry.DesktopEntry(desktop_path)
            icon_path = xdg.IconTheme.getIconPath(desktop_entry.getIcon())
            yield LauncherItem(
                desktop_entry.getName(),
                desktop_entry.getExec(),
                icon_path=icon_path
            )


def scan_for_executables(directories):
    for directory in directories:
        for entry in os.listdir(directory):
            path = os.path.join(directory, entry)
            if os.path.isfile(path) and os.access(path, os.X_OK):
                yield entry, path


def get_executables_on_path():
    directories = os.environ.get('PATH', '').split(os.pathsep)
    return scan_for_executables(directories)


def get_executables_matching_query(query):
    if not query:
        return []
    return (
        (executable, path)
        for executable, path in get_executables_on_path()
        if query in executable
    )


def generate_output(query, executables):
    return ''.join(
        '{{ {0} | {1} }}'.format(
            executable.replace(query, '%B{}%'.format(query), 1),
            path
        ) for executable, path in executables
    )


# TODO:
#   - Cache executables
#   - Remember recent entries (and weight them)
#   - Persist recent entries

while True:
    query = sys.stdin.readline().strip()
    print(generate_output(query, get_executables_matching_query(query)))
    sys.stdout.flush()
