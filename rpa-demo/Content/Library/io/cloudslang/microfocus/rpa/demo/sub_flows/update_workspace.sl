namespace: io.cloudslang.microfocus.rpa.demo.sub_flows
flow:
  name: update_workspace
  inputs:
    - username: sfdev
  workflow:
    - get_token:
        do:
          io.cloudslang.microfocus.rpa.designer.authenticate.get_token:
            - ws_user: '${username}'
        publish:
          - token
        navigate:
          - FAILURE: on_failure
          - SUCCESS: get_ws_id
    - get_ws_id:
        do:
          io.cloudslang.microfocus.rpa.designer.workspace.get_ws_id: []
        publish:
          - ws_id
        navigate:
          - FAILURE: on_failure
          - SUCCESS: update_workspace
    - update_workspace:
        do:
          io.cloudslang.microfocus.rpa.designer.workspace.update_workspace:
            - token: '${token}'
            - ws_id: '${ws_id}'
        publish:
          - process_status
          - status_json
          - binaries_status_json
        navigate:
          - FAILURE: get_repo_details
          - SUCCESS: logout
          - NO_SCM_REPOSITORY: logout
    - logout:
        do:
          io.cloudslang.microfocus.rpa.designer.authenticate.logout: []
        navigate:
          - SUCCESS: SUCCESS
    - get_repo_details:
        do:
          io.cloudslang.microfocus.rpa.designer.repository.get_repo_details:
            - ws_id: '${ws_id}'
        publish:
          - repo_id
          - scm_url
        navigate:
          - FAILURE: on_failure
          - SUCCESS: delete_repo
    - delete_repo:
        do:
          io.cloudslang.microfocus.rpa.designer.repository.delete_repo:
            - token: '${token}'
            - ws_id: '${ws_id}'
            - repo_id: '${repo_id}'
        navigate:
          - FAILURE: on_failure
          - SUCCESS: import_repo
    - import_repo:
        do:
          io.cloudslang.microfocus.rpa.designer.repository.import_repo:
            - token: '${token}'
            - ws_id: '${ws_id}'
            - scm_url: '${scm_url}'
        publish:
          - status_json
          - host_json
        navigate:
          - FAILURE: on_failure
          - SUCCESS: logout
    - on_failure:
        - logout_failure:
            do:
              io.cloudslang.microfocus.rpa.designer.authenticate.logout: []
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      get_token:
        x: 134
        'y': 115
      get_ws_id:
        x: 342
        'y': 117
      update_workspace:
        x: 539
        'y': 116
      logout:
        x: 712
        'y': 127
        navigate:
          0b2b7210-88ab-46cd-67b2-7860269649ff:
            targetId: 8ce08404-25fc-734a-68ab-7f8e24637112
            port: SUCCESS
      get_repo_details:
        x: 409
        'y': 298
      delete_repo:
        x: 589
        'y': 295
      import_repo:
        x: 772
        'y': 295
    results:
      SUCCESS:
        8ce08404-25fc-734a-68ab-7f8e24637112:
          x: 864
          'y': 117
