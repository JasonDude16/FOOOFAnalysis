import fooof
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt

def FOOOF_summaries (data_list, append=None, img_path=None, data_path=None, freq_range=[1,50]):
  
  df = []
  ID_list = list(data_list.keys())
  
  for ID in ID_list:
    spectrum = np.ravel(data_list[ID]['spectrum'])
    freqs = np.ravel(data_list[ID]['freqs'])
    fm = fooof.FOOOF(peak_width_limits= [1, 8], max_n_peaks= 8, min_peak_height= 0.05)
    fm.report(freqs, spectrum, freq_range = freq_range)
    plt.close()
    df.append([ID,
               fm.aperiodic_params_.round(decimals=3)[1],
               fm.r_squared_.round(decimals = 3),
               fm.error_.round(decimals = 3)])
    if img_path is not None:
      file = ID + "_" + append + '.png'
      fm.plot(save_fig= True, file_name=file, file_path=img_path)
      plt.close()

  df = pd.DataFrame(df, columns=['ID', 'aperiodic_exp', 'r_squared', 'model_error'])
  
  if data_path is not None: 
      file = data_path + "/models_" + append + ".csv"
      df.to_csv(file)
      
  return df 
