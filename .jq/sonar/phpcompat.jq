{
    issues: [
        . | keys[] as $k | if ((.[$k].messages | length) > 0) then {
            engineId: "PHPCompatibility",
            "ruleId": (
            if  .[$k].messages[].fixable == false then
                "Fixable"
            else
                "No fixable"
            end
            ),
            "severity": (
                if  .[$k].messages[].severity > 5 then
                    "BLOCKER"
                else
                    "CRITICAL"
                end
            ),
            "type": (
                if  .[$k].messages[].type == "error" then
                    "BUG"
                else
                    "VULNERABILITY"
                end
            ),
            effortMinutes: (
                if .[$k].messages[].fixable == false then
                    if  .[$k].messages[].type == "error" then
                        "800"
                    else
                        "400"
                    end
                else
                    if .[$k].messages[].type == "error" then
                        "200"
                    else
                        "100"
                    end
                end
            ),
            primaryLocation: {
                message: .[$k].messages[].message,
                filePath:  "\($k)",
                textRange: {
                    startLine: .[$k].messages[].line,
                    startColumn: .[$k].messages[].column,
                }
            }
        } else
            empty
        end
    ]
}
