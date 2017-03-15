function washout_simulation(time_start,time_stop,time_step_size,data_dictionary)

  # First - run the model to steady-state w/no ATRA forcing -
  XSS = estimate_steady_state(0.001,data_dictionary)

  # Next, set the IC to the steady-state value -
  initial_condition_array = XSS;
  number_of_states = length(XSS)
  data_dictionary["initial_condition_array"] = initial_condition_array;

  # Phase 1: Run the model 1/4 of the final time w/o ATRA
  # Run the model for a section of time w/no ATRA forcing -
  time_start_phase_1 = 0.0;
  time_stop_phase_1 = 1/6*time_stop;

  # Solve the model equations -
  (TP1,XP1) = SolveBalances(time_start_phase_1,time_stop_phase_1,time_step_size,data_dictionary);

  # set the ic -
  initial_condition_array = XP1[end,:];
  data_dictionary["initial_condition_array"] = initial_condition_array;

  # Grab the control parameters - turn on gene_1 =
  control_parameter_dictionary = data_dictionary["control_parameter_dictionary"]
  control_parameter_dictionary["W_gene_1_RNAP"] = 1.0;
  data_dictionary["control_parameter_dictionary"] = control_parameter_dictionary;

  # Run the model for a section of time w/no ATRA forcing -
  time_start_phase_2 = time_stop_phase_1+time_step_size
  time_stop_phase_2 = 10/24*time_stop

  # Solve the model equations -
  (TP2,XP2) = SolveBalances(time_start_phase_2,time_stop_phase_2,time_step_size,data_dictionary);

  # Washout -
  initial_condition_array = XP2[end,:];
  data_dictionary["initial_condition_array"] = initial_condition_array;

  # Grab the control parameters - turn on gene_1 =
  control_parameter_dictionary = data_dictionary["control_parameter_dictionary"]
  control_parameter_dictionary["W_gene_1_RNAP"] = 0.0;
  data_dictionary["control_parameter_dictionary"] = control_parameter_dictionary;

  time_start_phase_3 = time_stop_phase_2+time_step_size
  time_stop_phase_3 = time_stop
  (TP3,XP3) = SolveBalances(time_start_phase_3,time_stop_phase_3,time_step_size,data_dictionary);

  # Package the two phases together -
  T = [TP1 ; TP2 ; TP3];
  X = [XP1 ; XP2 ; XP3];

  return (T,X);
end

function adj_washout_inducer(time_start, time_stop, time_step_size, parameter_index, data_dictionary)

  # First - run the model to steady-state w/o inducer -
  XSS = estimate_steady_state(0.001,data_dictionary)

  # Next, set the IC to the steady-state value -
  initial_condition_array = XSS;
  number_of_states = length(XSS)
  initial_condition_array = [initial_condition_array ; zeros(number_of_states)]
  data_dictionary["initial_condition_array"] = initial_condition_array;

  # Phase 1: Run the model 1/10 of the final time w/o inducer
  # Run the model for a section of time w/no inducer -
  time_start_phase_1 = time_start;
  time_stop_phase_1 = 0.1*time_stop;

  # Solve the model equations -
  (TP1,XP1) = SolveAdjBalances(time_start_phase_1,time_stop_phase_1,time_step_size,parameter_index,data_dictionary);

  # Grab the control parameters - turn on gene_1 =
  control_parameter_dictionary = data_dictionary["control_parameter_dictionary"]
  control_parameter_dictionary["W_gene_1_RNAP"] = 1.0;    #? this parameter means
  data_dictionary["control_parameter_dictionary"] = control_parameter_dictionary;

  # Set the IC to the end of phase 1
  initial_condition_array = XP1[end,:];
  data_dictionary["initial_condition_array"] = initial_condition_array;

  # Run the model for a section of time w/no ATRA forcing -
  time_start_phase_2 = time_stop_phase_1+time_step_size
  time_stop_phase_2 = 0.5*time_stop

  # Solve the model equations -
  (TP2,XP2) = SolveAdjBalances(time_start_phase_2,time_stop_phase_2,time_step_size,parameter_index,data_dictionary);

  # Washout -
  initial_condition_array = XP2[end,:];
  data_dictionary["initial_condition_array"] = initial_condition_array;

  # Grab the control parameters - turn on gene_1 =
  control_parameter_dictionary = data_dictionary["control_parameter_dictionary"]
#  control_parameter_dictionary["W_gene_1_RNAP"] = 0.0; # for dynamic process
  control_parameter_dictionary["W_gene_1_RNAP"] = 1.0; #  steady state
  data_dictionary["control_parameter_dictionary"] = control_parameter_dictionary;

  time_start_phase_3 = time_stop_phase_2+time_step_size
  time_stop_phase_3 = time_stop
  (TP3,XP3) = SolveAdjBalances(time_start_phase_3,time_stop_phase_3,time_step_size,parameter_index,data_dictionary);

  # Package the two phases together -
  T = [TP1 ; TP2 ; TP3];
  X = [XP1 ; XP2 ; XP3];

  return (T,X);
end
