from textgenrnn import textgenrnn 

model = textgenrnn()
model.train_from_file('gnnData.txt',num_epochs = 10)



model.generate_to_file('generated.txt',n = 100,temperature = 0.3)