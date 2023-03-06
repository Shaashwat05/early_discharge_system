import json
from glob import glob
from urllib import parse, request

from companion_api import query


def filler(patient):
    if len(query(f"(isa {patient} ?who)"))!=0:
        lines = list()
        proc = query(f"(procedureType {patient} ?procedure)")[0]["procedure"]
        lines.append("(procedureType patient1 "+proc+")")
        if len(query(f"(deviceCheckNormal ?patient)"))!=0:
            lines.append("(deviceCheckNormal patient1)")
        for param in query(f"(reading {patient} ?param ?value)"):
            lines.append(f"(= (reading {param['param']}) {param['value']})")
        return lines
    else:
        raise NameError(patient +" does not exist")

def problem_gen(patient):
    templates = glob("templates/*Template.pddl")
    problems = list()
    tasks = list(map(lambda x:x[10:-13], templates))

    for template in templates:
        with open(template, "r") as f:
            problems.append(f.read())
    
    replacement = "\n    ".join(filler(patient))

    problems = list(map(lambda x:x.replace(";;;;", replacement), problems))

    return {task:problem for task, problem in zip(tasks, problems)}

def get_problem_result(problem):
    with open('domain.pddl', 'r') as domain_file:
        data = {'domain': domain_file.read(), 'problem': problem}
    response = {}
    while not response or response['result'] == 'Server busy...':
        try:
            response = json.loads(request.urlopen(request.Request('http://solver.planning.domains/solve', data=parse.urlencode(data).encode('utf-8'))).read())
        except:
            pass

    # print(response['status'])
    # if response['status'] != 'ok':
    #     if 'error' in response['result']:
    #         print(response['result']['error'])
    return response['status']#, response['result']['output'].strip() if 'output' in response['result'] else None

def get_outcomes(patient):
    problems = problem_gen(patient)
    outcomes = dict()
    for k in problems:
        outcomes[k] = get_problem_result(problems[k])
    return outcomes

def main():
    print(get_outcomes("JohnDoe"))
    print(get_outcomes("JaneDoe"))
    print(get_outcomes("TomDoe"))
    print(get_outcomes("AliceDoe"))

if __name__ == "__main__":
    main()