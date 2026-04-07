# Documentación del Algoritmo (Optimización por Colonia de Hormigas)

El código implementado en el Notebook se basa en el algoritmo de **Optimización por Colonia de Hormigas (ACO - Ant Colony Optimization)**. Aunque habitualmente se confunde o engloba dentro de los algoritmos evolutivos/genéticos, su funcionamiento se basa en actualizar rastros artificiales (feromonas).

A continuación se detalla qué afecta cada atributo y cómo instanciar e invocar una prueba del algoritmo.

---

## 1. Atributos del Algoritmo y sus Efectos

Para configurar el algoritmo se utiliza un objeto `SimpleNamespace` al que se le pasan las distintas directrices. Cada variable tiene un propósito fundamental en el entrenamiento del modelo:

*   **`name`** (`str`)
    *   **Efecto**: Define el nombre (y carpeta) raíz para cargar los datos del problema desde el directorio `data/`. Carga inteligentemente el archivo base (`.tsp`) y su respectiva solución óptima de validación (`.opt.tour`). 
    *   *Ejemplo*: `"medium/st70"`
*   **`n_gen`** (`int`) - *Número de Generaciones*
    *   **Efecto**: Determina la cantidad máxima de iteraciones globales. Entre más generaciones haya, el algoritmo tendrá más oportunidades de converger reforzando gradualmente el mejor camino encontrado.
*   **`n_ants`** (`int`) - *Número de Hormigas (Población)*
    *   **Efecto**: Equivale al tamaño de la "Población" de la generación. En cada iteración se envían esta cantidad de hormigas para construir una solución (una ruta completa). Más hormigas benefician la exploración en el espacio de búsqueda (diversidad) pero aumentan la carga de procesamiento o tiempo de ejecución.
*   **`alpha`** (`float`) - *Importancia del Rastro de Feromonas*
    *   **Efecto**: Controla la influencia probabilística de la "experiencia pasada" en la elección de los caminos. Si es muy alto, las hormigas seguirán casi ciegamente los caminos buenos previos (puede converger muy rápido a un óptimo local y quedarse estancado).
*   **`beta`** (`float`) - *Importancia de la Información Heurística*
    *   **Efecto**: Controla la "visibilidad" (heurística golosa), que en este caso es el inverso de la distancia entre ciudades ($1/distance$). Un valor de `beta` alto forzará a la hormiga a saltar simplemente hacia su vecino físico más cercano ignorando las feromonas largas.
*   **`p`** (`float`) - *Retención de Feromona*
    *   **Efecto**: Es el inverso a la tasa de evaporación ($\rho$). Funciona multiplicando y atenuando la feromona matriz en cada iteración (`tho = p * tho`). Un valor de `0.3` significa que en cada generación el 30% de la feromona histórica del camino se retiene y el otro 70% se evapora; de esta forma se reduce la importancia temporal evitando el estancamiento.
*   **`delta`** (`float`) - *Factor de Depósito de Feromonas*
    *   **Efecto**: Constante heurística que dosifica en qué magnitud se va a premiar (reforzar) con feromonas extras el mejor camino recorrido en la iteración. Actúa según la formulación `obj.delta / best_global_length`.
*   **`show_population`** (`bool`) - *Control de Renderizado*
    *   **Efecto**: Si se activa en `True`, las gráficas animadas van a mostrar las rutas que tomaron absolutamente todos los elementos en la generación (subrayadas en líneas grises atenuadas), además de mostrar en color la mejor de la generación.

---

## 2. Cómo Ejecutar un Test del Algoritmo

Hacer un test dentro del Jupyter Notebook ya estipulado consiste esencialmente en dos pasos:

### Paso 1: Configurar los Parámetros
Utiliza un objeto `SimpleNamespace` para declarar con precisión cómo deseas que se comporte el barrido. 

```python
from types import SimpleNamespace

config_test = SimpleNamespace(
    name="high/gr202",       # Nombre y ubicacion del dataset
    n_gen=40,                # Iteraciones del algoritmo
    n_ants=500,              # Tamaño del enjambre
    alpha=1.0,               # Fuerza de la feromona
    beta=2.5,                # Fuerza de la cercanía de ciudades
    p=0.5,                   # Multiplicador condicional de la matriz de retención
    delta=1.0,               # Carga del refuerzo del trayecto
    show_population=False    # Recomendable 'False' en n_ants grandes
)
```

### Paso 2: Invocar la Función
Simplemente llamas la función `test_algo()` pasándole la configuración que creaste en el paso anterior. Asumiendo que las utilidades previamente dadas están importadas en celdas de arriba.

```python
test_algo(config_test)
```

### ¿Qué se renderizará como resultado?
La función orquestará el test completo de la siguiente manera:
1. Imprimirá en consola cada récord si se ha superado la **"Mejor Longitud" (Global)**.
2. Renderizará visualizadores para **Animación de rutas**, dibujando dinámicamente cómo las hormigas descubrieron senderos generación tras generación.
3. Imprimirá un panel con **Estadísticas de caída** revelando el historial o curva temporal del coste/distancia.
4. Generará una gráfica estática comparativa (**Ruta Óptima Conocida** contra **Mejor Ruta de Hormigas**).
5. Devolverá abajo y en consola un resumen de eficiencia revelando una métrica crítica de **Eficiencia del algoritmo (%)**, calculando el diferencial (*GAP*) contra la mejor solución del archivo `.opt.tour`.
