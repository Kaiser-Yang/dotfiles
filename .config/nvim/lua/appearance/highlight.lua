--- @class HighlightConfig
--- @field [1] number -- The ns id, 0 for global highlights
--- @field [2] string -- The name of the highlight group
--- @field [3] vim.api.keyset.highlight -- The configuration for the highlight group

--- @type HighlightConfig[]
return {
    { 0, 'DapStopped', { fg = '#98C379' } },
    { 0, 'DapStoppedLine', { bg = '#31353F' } },
    { 0, 'DapBreakpointRejected', { fg = '#888888' } },

    { 0, 'FoldOpen', { fg = '#89b4fa' } },
    { 0, 'FoldClosed', { fg = '#89b4fa' } },

    { 0, 'BlinkCmpGitKindIconCommit', { fg = '#a6e3a1' } },
    { 0, 'BlinkCmpGitKindIconopenPR', { fg = '#a6e3a1' } },
    { 0, 'BlinkCmpGitKindIconopenedPR', { fg = '#a6e3a1' } },
    { 0, 'BlinkCmpGitKindIconclosedPR', { fg = '#f38ba8' } },
    { 0, 'BlinkCmpGitKindIconmergedPR', { fg = '#cba6f7' } },
    { 0, 'BlinkCmpGitKindIcondraftPR', { fg = '#9399b2' } },
    { 0, 'BlinkCmpGitKindIconlockedPR', { fg = '#f5c2e7' } },
    { 0, 'BlinkCmpGitKindIconopenIssue', { fg = '#a6e3a1' } },
    { 0, 'BlinkCmpGitKindIconopenedIssue', { fg = '#a6e3a1' } },
    { 0, 'BlinkCmpGitKindIconreopenedIssue', { fg = '#a6e3a1' } },
    { 0, 'BlinkCmpGitKindIconcompletedIssue', { fg = '#cba6f7' } },
    { 0, 'BlinkCmpGitKindIconclosedIssue', { fg = '#cba6f7' } },
    { 0, 'BlinkCmpGitKindIconnot_plannedIssue', { fg = '#9399b2' } },
    { 0, 'BlinkCmpGitKindIconduplicateIssue', { fg = '#9399b2' } },
    { 0, 'BlinkCmpGitKindIconlockedIssue', { fg = '#f5c2e7' } },
    { 0, 'BlinkCmpGitKindLabelCommitId', { fg = '#a6e3a1' } },
    { 0, 'BlinkCmpGitKindLabelopenPRId', { fg = '#a6e3a1' } },
    { 0, 'BlinkCmpGitKindLabelopenedPRId', { fg = '#a6e3a1' } },
    { 0, 'BlinkCmpGitKindLabelclosedPRId', { fg = '#f38ba8' } },
    { 0, 'BlinkCmpGitKindLabelmergedPRId', { fg = '#cba6f7' } },
    { 0, 'BlinkCmpGitKindLabeldraftPRId', { fg = '#9399b2' } },
    { 0, 'BlinkCmpGitKindLabellockedPRId', { fg = '#f5c2e7' } },
    { 0, 'BlinkCmpGitKindLabelopenIssueId', { fg = '#a6e3a1' } },
    { 0, 'BlinkCmpGitKindLabelopenedIssueId', { fg = '#a6e3a1' } },
    { 0, 'BlinkCmpGitKindLabelreopenedIssueId', { fg = '#a6e3a1' } },
    { 0, 'BlinkCmpGitKindLabelcompletedIssueId', { fg = '#cba6f7' } },
    { 0, 'BlinkCmpGitKindLabelclosedIssueId', { fg = '#cba6f7' } },
    { 0, 'BlinkCmpGitKindLabelnot_plannedIssueId', { fg = '#9399b2' } },
    { 0, 'BlinkCmpGitKindLabelduplicateIssueId', { fg = '#9399b2' } },
    { 0, 'BlinkCmpGitKindLabellockedIssueId', { fg = '#f5c2e7' } },
    { 0, 'BlinkCmpKindDict', { fg = '#a6e3a1' } },
}
