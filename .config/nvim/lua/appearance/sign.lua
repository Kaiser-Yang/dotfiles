--- @class SignConfig
--- @field [1] string The name of the sign
--- @field [2] vim.fn.sign_define.dict The configuration for the sign

--- @type SignConfig[]
return {
    {
        'FoldOpen',
        { text = '', texthl = 'FoldOpen' },
    },
    {
        'FoldClosed',
        { text = '', texthl = 'FoldClosed' },
    },
    {
        'DapStopped',
        { text = '▶', texthl = 'DapStopped', linehl = 'DapStoppedLine' },
    },
    { 'DapLogPoint', { text = '', texthl = 'DapLogPoint' } },
    { 'DapBreakpoint', { text = '●', texthl = 'DapBreakpoint' } },
    {
        'DapBreakpointRejected',
        { text = 'x', texthl = 'DapBreakpointRejected' },
    },
    {
        'DapBreakpointCondition',
        { text = '○', texthl = 'DapBreakpointCondition' },
    },
}
