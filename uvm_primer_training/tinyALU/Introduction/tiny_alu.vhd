library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tiny_alu is
  port (
    clk    : in  std_logic;
    rst_n  : in  std_logic;
    start  : in  std_logic;
    op     : in  std_logic_vector(2 downto 0);
    a      : in  std_logic_vector(7 downto 0);
    b      : in  std_logic_vector(7 downto 0);
    result : out std_logic_vector(15 downto 0);
    done   : out std_logic
  );
end tiny_alu;

architecture rtl of tiny_alu is
  signal res_single : std_logic_vector(15 downto 0) := (others => '0');
  signal mul_pipe0, mul_pipe1, mul_pipe2 : std_logic_vector(15 downto 0) := (others => '0');
  signal mul_valid0, mul_valid1, mul_valid2 : std_logic := '0';
begin
  -- single-cycle ops
  process(clk)
  begin
    if rising_edge(clk) then
      if rst_n = '0' then
        res_single <= (others => '0');
      else
        case op is
          when "001" => res_single <= std_logic_vector(resize(unsigned(a),16) + resize(unsigned(b),16));
          when "010" => res_single <= (15 downto 8 => '0') & (a and b);
          when "011" => res_single <= (15 downto 8 => '0') & (a xor b);
          when others => null;
        end case;
      end if;
    end if;
  end process;

  -- 3-stage multiply pipeline
  process(clk)
  begin
    if rising_edge(clk) then
      if rst_n = '0' then
        mul_pipe0 <= (others => '0'); mul_pipe1 <= (others => '0'); mul_pipe2 <= (others => '0');
        mul_valid0 <= '0'; mul_valid1 <= '0'; mul_valid2 <= '0';
      else
        if start = '1' and op = "100" then
          mul_pipe0  <= std_logic_vector(resize(unsigned(a),16) * resize(unsigned(b),16));
          mul_valid0 <= '1';
        else
          mul_pipe0  <= (others => '0'); mul_valid0 <= '0';
        end if;
        mul_pipe1 <= mul_pipe0; mul_valid1 <= mul_valid0;
        mul_pipe2 <= mul_pipe1; mul_valid2 <= mul_valid1;
      end if;
    end if;
  end process;

  result <= res_single when op(2) = '0' else mul_pipe2;
  done   <= start when op(2) = '0' else mul_valid2;
end rtl;
