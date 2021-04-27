########################################################################################################################
#!!
#! @description: Updates the RPA demo instance data; it
#!               - generates ROI numbers
#!               - downloads and deploys the newest released CPs from GitHub repositories
#!               - updates workspaces of demo users (updates RPA activies + pulls changes in SCM repositories)
#!!#
########################################################################################################################
namespace: io.cloudslang.microfocus.oo.demo
flow:
  name: update_rpa_demo_instance
  inputs:
    - roi_path: Library/Micro Focus/Misc
    - roi_number_of_occurences_range: 1-10
    - roi_range: 5-20
    - cp_folder: "C:\\\\Users\\\\Administrator\\\\Downloads\\\\demo-content-packs"
    - github_repos: 'pe-pan/rpa-aos,pe-pan/rpa-sap,pe-pan/rpa-salesforce,rpa-micro-focus/rpa-microsoft-graph,rpa-micro-focus/cs-base-te-addon,rpa-micro-focus/rpa-rpa,rpa-micro-focus/rpa-demo,rpa-micro-focus/rpa-demo-updater,rpa-micro-focus/cs-microfocus-enterprise-server'
    - usernames: 'admin,aosdev,sapdev,sfdev,rpadev,rpademo,rpaqa,addondev,addonqa,esdev'
  workflow:
    - generate_roi_numbers:
        do:
          io.cloudslang.microfocus.oo.demo.generate_roi_numbers:
            - path: '${roi_path}'
            - num_of_occurences_range: '${roi_number_of_occurences_range}'
            - roi_range: '${roi_range}'
        navigate:
          - FAILURE: update_cp_from_github
          - SUCCESS: update_cp_from_github
    - update_cp_from_github:
        loop:
          for: github_repo in github_repos
          do:
            io.cloudslang.microfocus.oo.central.content-pack.update_cp_from_github:
              - github_repo: '${github_repo}'
              - cp_folder: '${cp_folder}'
          break: []
        navigate:
          - FAILURE: update_workspace
          - NOTHING_TO_UPDATE: update_workspace
          - ALREADY_DEPLOYED: update_workspace
          - SUCCESS: update_workspace
    - update_workspace:
        loop:
          for: username in usernames
          do:
            io.cloudslang.microfocus.oo.demo.sub_flows.update_workspace:
              - username: '${username}'
          break: []
        navigate:
          - FAILURE: on_failure
          - SUCCESS: SUCCESS
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      generate_roi_numbers:
        x: 73
        'y': 72
      update_cp_from_github:
        x: 316
        'y': 73
      update_workspace:
        x: 602
        'y': 73
        navigate:
          f1f56ab3-e8b0-a138-d75e-38a48180f782:
            targetId: 79615ce1-e9d4-4686-6566-2e5cf0b3f543
            port: SUCCESS
    results:
      SUCCESS:
        79615ce1-e9d4-4686-6566-2e5cf0b3f543:
          x: 840
          'y': 72
