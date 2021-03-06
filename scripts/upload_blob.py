#Quick start script. Tweaked a bit and tested and it works well. Proof of concept as to how to maniplate Azure storage with Python. Comment out what you need.

#3/6/2020
# Creates a container in an existing Azure Storage account. Uploads a local file. Downloads the file. Then deletes the Azure container adn the local files. 
# 
#

import os
import uuid
from azure.storage.blob import BlobServiceClient, BlobClient, ContainerClient

try:
    print("Azure Blob storage v12 - Python quickstart sample")
    # Quick start code goes here
    # Retrieve the connection string for use with the application. The storage
    # connection string is stored in an environment variable on the machine
    # running the application called AZURE_STORAGE_CONNECTION_STRING. If the environment variable is
    # created after the application is launched in a console or with Visual Studio,
    # the shell or application needs to be closed and reloaded to take the
    # environment variable into account.
    connect_str = os.getenv('AZURE_STORAGE_CONNECTION_STRING')
    # Create the BlobServiceClient object which will be used to create a container client
    blob_service_client = BlobServiceClient.from_connection_string(connect_str)

    # Create a unique name for the container
    container_name = "quickstart" + str(uuid.uuid4())

    # Create the container
    container_client = blob_service_client.create_container(container_name)

    # Create a file in local Documents directory to upload and download
    local_path = "./data"
    local_file_name = "quickstart" + str(uuid.uuid4()) + ".txt"
    upload_file_path = os.path.join(local_path, local_file_name)

    # Write text to the file
    file = open(upload_file_path, 'w')
    file.write("Hello, World!")
    file.close()

    # Create a blob client using the local file name as the name for the blob
    blob_client = blob_service_client.get_blob_client(
        container=container_name, blob=local_file_name)

    print("\nUploading to Azure Storage as blob:\n\t" + local_file_name)

    # Upload the created file
    with open(upload_file_path, "rb") as data:
        blob_client.upload_blob(data)

    print("\nListing blobs...")

    # List the blobs in the container
    blob_list = container_client.list_blobs()
    for blob in blob_list:
        print("\t" + blob.name)

    # Download file
    # Download the blob to a local file
    # Add 'DOWNLOAD' before the .txt extension so you can see both files in Documents
    download_file_path = os.path.join(local_path, str.replace(local_file_name ,'.txt', 'DOWNLOAD.txt'))
    print("\nDownloading blob to \n\t" + download_file_path)

    with open(download_file_path, "wb") as download_file:
        download_file.write(blob_client.download_blob().readall())


    # Nuke the blob
    print("Deleting blob" + blob_client.blob_name )
    
    input()
    
    blob_client.delete_blob(delete_snapshots="include")
    



    # # Clean up
    # print("\nPress the Enter key to begin clean up")
    # input()

    # print("Deleting blob container...")
    # container_client.delete_container()

    # print("Deleting the local source and downloaded files...")
    # os.remove(upload_file_path)
    # os.remove(download_file_path)

    print("Done")
except Exception as ex:
    print('Exception:')
    print(ex)
