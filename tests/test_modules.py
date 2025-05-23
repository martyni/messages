'''
   Testing module imports
'''
# pylint: disable=W0122
from os import listdir, chdir, path

ROOT = path.abspath('.')
TESTS_DIR = f'{ROOT}/tests'
SRC = f'{ROOT}/src'
chdir(SRC)
MODULES = listdir()
print(MODULES)
chdir(ROOT)
SUBMODULES = []


def test_module_imports():
    '''
    Import modules
    '''
    for mod in MODULES:
        if 'egg-info' in mod:
            continue
        exec(f'import {mod}')
        assert exec('{mod}') is not False, f'Could not import {mod}'
        chdir(SRC)
        for submod in listdir(f'{mod}'):
            if '__init__' in submod:
                break
            submod = submod.split('.py')[0]
            exec(f'import {mod}.{submod}')
            SUBMODULES.append(f'{mod}_{submod}')
            assert exec(
                f'{mod}.{submod}') is not False, f'Could not initialize {mod}.{submod}'
    chdir(ROOT)


def test_coverage():
    '''
    Check each coverage
    '''
    tests = listdir(TESTS_DIR)
    for submod in SUBMODULES:
        print(submod)
        assert f'test_{submod}.py' in tests


if __name__ == '__main__':
    test_module_imports()
    test_coverage()
