namespace: io.cloudslang.microfocus.oo.demo.sub_flows
flow:
  name: unassign_user_cps
  inputs:
    - token
    - ws_id
  workflow:
    - get_assigned_cps:
        do:
          io.cloudslang.microfocus.oo.designer.content-pack.get_assigned_cps:
            - ws_id: '${ws_id}'
        publish:
          - cps_json
        navigate:
          - FAILURE: on_failure
          - SUCCESS: json_path_query
    - unassign_cp:
        loop:
          for: cp_id in eval(cp_ids)
          do:
            io.cloudslang.microfocus.oo.designer.content-pack.unassign_cp:
              - token: '${token}'
              - ws_id: '${ws_id}'
              - cp_id: '${cp_id}'
          break:
            - FAILURE
        navigate:
          - FAILURE: on_failure
          - SUCCESS: SUCCESS
    - json_path_query:
        do:
          io.cloudslang.base.json.json_path_query:
            - json_object: '${cps_json}'
            - json_path: '$[?(@.type == "CONTENTPACK")].id'
        publish:
          - cp_ids: '${return_result}'
        navigate:
          - SUCCESS: no_cp_assigned
          - FAILURE: on_failure
    - no_cp_assigned:
        do:
          io.cloudslang.base.utils.is_true:
            - bool_value: "${str(cp_ids == '[]')}"
        navigate:
          - 'TRUE': SUCCESS
          - 'FALSE': unassign_cp
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      get_assigned_cps:
        x: 39
        'y': 76
      unassign_cp:
        x: 618
        'y': 80
        navigate:
          d6be61fd-3ca7-c12d-cda8-b2ceffd6bc97:
            targetId: 5d365ffe-9281-8c41-d5d5-c14af3987009
            port: SUCCESS
      json_path_query:
        x: 213
        'y': 77
      no_cp_assigned:
        x: 423
        'y': 78
        navigate:
          70c0d3a9-38ab-3aca-3c0e-d1f578b30376:
            targetId: 5d365ffe-9281-8c41-d5d5-c14af3987009
            port: 'TRUE'
    results:
      SUCCESS:
        5d365ffe-9281-8c41-d5d5-c14af3987009:
          x: 524
          'y': 288
