<#Purpose: Iterate through a text file containing complete file paths in order to capture the 
  file path, document name, file type, and date last modified for all the files#>
  
#Initialize Object variable as an array  
$object = @()

do{

    #Prompt user to enter file path (9999 to exit)
    $FolderPath = Read-Host -Prompt 'Input folder path (Enter 9999 to exit)' 
    
    #Checks if user input is a valid folder path
    if(Test-Path $FolderPath){
     
        Get-ChildItem "$FolderPath" -Recurse | Foreach-Object {

            #Checks for files
            if($_ -is [System.IO.FileInfo]){
                
                #Captures File Path
                $FilePath = $_.Fullname
            
                #Captures the Document Name
                $DocumentName = Split-Path $_ -leaf
        
                #Captures the File Extension
                $FileType = [System.IO.Path]::GetExtension($_)
   
                #Captures the Date Last Modified
                $Date = $_.LastWriteTime

                #Properties that format the chart into separate columns
                $object += New-Object PSObject -Prop @{'FilePath'=$FilePath;
                            'DocumentName'=$DocumentName;
                            'FileType'=$FileType;
                            'Date'=$Date}

            }
        }  
    }
    else{
        if($FolderPath -match '9999'){
            #Breaks loop if user input is 9999
            break
         }
        else{
            #Prompts the user to enter a valid folder path
            $FolderPath = Read-Host -Prompt 'Invalid path: Enter folder path (Enter 9999 to exit)'
        }
    }
}while($FolderPath -notmatch '9999')

#Stores results in text file
        $object | Select-Object FilePath,DocumentName,FileType,Date | Format-Table -Wrap | Out-File C:\Users\csimmo07\Documents\trail.txt -append 



