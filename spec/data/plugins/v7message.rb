Ohai.plugin(:V7message) do
  provides 'v7message'

  collect_data do
    v7message "v7 plugins are awesome!"
  end
end
