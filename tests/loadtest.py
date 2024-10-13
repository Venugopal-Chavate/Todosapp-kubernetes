import requests
import time
import threading

def send_request(url):
    while True:
        try:
            response = requests.get(url)
            print(f"Status Code: {response.status_code}")
        except requests.exceptions.RequestException as e:
            print(f"Request failed: {e}")
        time.sleep(0.1)  # 100ms delay between requests

def main():
    url = "http://35.190.229.112/"  # Replace with your frontend IP
    num_threads = 10  # Adjust based on your needs

    threads = []
    for _ in range(num_threads):
        thread = threading.Thread(target=send_request, args=(url,))
        thread.start()
        threads.append(thread)

    for thread in threads:
        thread.join()

if __name__ == "__main__":
    main()