# PowerShell script: get_fw_rules.ps1
# Выводит только созданные правила брандмаузера и их основные свойства

# Список имен созданных правил
$ruleNames = @(
    "Block_http_conn",
    "Allow_rdp_conn",
    "Block_ftp_conn",
    "Block_ping_conn"
)

# Получаем объекты правил по имени
$rules = Get-NetFirewallRule -Name $ruleNames -ErrorAction SilentlyContinue

# Для каждого правила собираем нужные свойства
$result = foreach ($rule in $rules) {
    # Проверяем фильтр (если есть)
    $portFilter = Get-NetFirewallPortFilter -AssociatedNetFirewallRule $rule -ErrorAction SilentlyContinue
    # ICMP фильтр (если есть)
    $icmpFilter = Get-NetFirewallSetting -ErrorAction SilentlyContinue

    [PSCustomObject]@{
        Name        = $rule.DisplayName
	Enabled	    = $rule.Enabled
	Direction   = $rule.Direction
	Protocol    = if ($portFilter) { $portFilter.Protocol } elseif ($rule.Protocol -ne 'Any') { $rule.Protocol } else { 'Any'}
	LocalPort   = if ($portFilter) { ($portFilter.LocalPort -join ',') } else { '-' }
	RemotePort  = if ($portFilter) { ($portFilter.RemotePort -join ',') } else { ',' }
	Action      = $rule.Action
	Profile     = ($rule.Profile-join ',')
    }
}

# Печатаем результат в табличном виде
$result | Format-Table -AutoSize
