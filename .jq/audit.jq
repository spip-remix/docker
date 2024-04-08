{
    issues:[
        .[][]| keys[] as $k  | {
            engineId: "composer audit",
            ruleId: "Audit",
            severity: "CRITICAL",
            type: "VULNERABILITY",
            effortMinutes: 800,
            primaryLocation: {
            message: (.[$k].packageName + ", "+ .[$k].cve + ", " + .[$k].title + ", " + .[$k].link),
            filePath: "composer.lock",
                "textRange": {
                    "startLine": 1
                }
            }
        }
    ]
}
