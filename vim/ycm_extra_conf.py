flags = [
    '-Wall',
    '-Wextra',
    '-Werror',
    '-fexceptions',
    '-std=c++11',
    '-x',
    'c++',
    '-isystem',
    '/usr/include',
    '-isystem',
    '/usr/local/include',
]


def Settings(**kwargs):
    return {'flags': flags}
