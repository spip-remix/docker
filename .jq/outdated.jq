{
    issues: [
        .[][] | {
            engineId: "composer outdated",
            ruleId: (
                if .abandoned == false then
                    "DEPRECATED"
                elif (.abandoned | type) == "string" or  .abandoned == true then
                    "ABANDONED"
                else
                    "Unknow"
                end
            ),
            severity: (
                if .abandoned == false then
                    if ."latest-status" == "update-possible" then
                        "MAJOR"
                    else
                        "MINOR"
                    end
                else
                    if (.abandoned | type) == "string" then
                        "MAJOR"
                    else
                        "CRITICAL"
                    end
                end
            ),
            type: (if .version | test("^dev-") then "BUG" else "VULNERABILITY" end),
            "effortMinutes": (
                if  .abandoned == false then
                    if ."latest-status" == "update-possible" then
                        400
                    else
                        30
                    end
                else
                    if (.abandoned | type) == "string" then
                        400
                    else
                        800
                    end
                end
            ),
            primaryLocation: {
                message: (
                    if .abandoned == false then
                        .name + ": actual:"+."version" + " -> latest:" + ."latest"
                    elif .abandoned == true or  (.abandoned | type) == "string" then
                        .warning
                    else
                        "Unknow error"
                    end
                ),
                filePath: "composer.lock",
                "textRange": {
                    "startLine": 1
                }
            }
        }
    ]
}
