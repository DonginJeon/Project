import shutil, os



def remover(path):
    try:
        shutil.rmtree(path)
        os.makedirs(path)
        return True
    except Exception as e:
        print(f"Remover Error MSG: {e}")
        return False