rule Detect_Mimikatz_Process
{
    meta:
	description= "detects process name mimikatz"
    
    strings:
        $mz = "mimikatz" nocase

    condition:
        $mz
}

rule Detect_Shadow_Path
{
    meta:
        description= "detects access to /etc/shadow"

    strings:
        $shadow = "/etc/shadow"

    condition:
        $shadow
}

rule Detect_Reverse_Shell
{
    meta:
        description= "detects reverse shell indicators"

    strings:
        $rs = /reverse[_ ]shell/i

    condition:
        $rs
}
