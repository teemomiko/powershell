'''
Ver:1.0
Author: Aoteman

'''
$userid='it_infor@cootek.cn'
$pass= get-content C:\Users\teemo\Desktop\inforcootek.txt| convertto-securestring
$cred1 = New-Object System.Management.Automation.PSCredential($userid,$pass)
$cred = Get-Credential $cred1
# Connect-MSolService -credential $cred  
$Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri  https://partner.outlook.cn/PowerShell-liveid/ -Credential $cred -Authentication Basic  -AllowRedirection
Import-PSSession $Session -AllowClobber -DisableNameChecking
Import-Module MSOnline   


function mailcleandoublecheck {
    param (
        $emailaddress
    )
    $sent = get-messageTrace -Start $StartDate -End $EndDate   -SenderAddress $emailaddress | Measure-Object
    $rec = get-messageTrace -Start $StartDate -End $EndDate  -RecipientAddress $emailaddress | Measure-Object
    $totalcount  = $sent.count + $rec.count
    return $totalcount
    
}


#"ResourceUsageLastInteractiveClientTime 参数显示用户上一次与 Exchange Server 进行交互的时间戳。"


#search all shared_mailbox

$mail_lists = Get-Mailbox  -Filter *  -ResultSize Unlimited  | Select-Object PrimarySmtpAddress,RecipientTypeDetails  | Where-Object {$_.RecipientTypeDetails  -like '*SharedMailbox*'}

#Seach all shared_mailbox  fullified  []

$list = @()
$array =@()
$array1 =@()
[System.Collections.ArrayList]$resultlist = $list
[System.Collections.ArrayList]$queues = $array
[System.Collections.ArrayList]$finalresults = $array1
$Client_StartDate = (Get-Date).AddDays(-60)
$last_LogonDate = (Get-Date).AddDays(-30)
$EndDate = Get-Date
$StartDate = (Get-Date).AddDays(-10)

foreach($mail_list in $mail_lists)
    {

        $compare = Get-MailboxStatistics $mail_list[0].PrimarySmtpAddress | select ResourceUsageLastInteractiveClientTime,LastLogoffTime,LastLogonTime
        if(($compare.ResourceUsageLastInteractiveClientTime -lt $Client_StartDate) -or ($compare.LastLogonTime -lt $last_LogonDate) )
            {
                 $result= $mail_list[0].PrimarySmtpAddress+','+$compare.ResourceUsageLastInteractiveClientTime+','+$compare.LastLogonTime
                 $resultlist.Add($result)
                 $queues.Add($mail_list[0].PrimarySmtpAddress)
            }
    }

#use meassage trace  to  double check  

foreach ($queue in $queues)
    {

        if(mailcleandoublecheck($queue) -lt 1)
          {

            $finalresults.Add($queue)
          }

    }
# 显示结果



