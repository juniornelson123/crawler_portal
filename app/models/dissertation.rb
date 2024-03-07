class Dissertation < ApplicationRecord

  enum kind: { admin: 0, direito: 1, educacao: 2, odontologia: 3, family: 4 }
end
